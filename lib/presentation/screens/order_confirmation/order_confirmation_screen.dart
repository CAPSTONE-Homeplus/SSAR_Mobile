import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/core/enums/wallet_enums.dart';
import 'package:home_clean/domain/entities/transaction/create_transaction.dart';
import 'package:home_clean/presentation/blocs/service_in_house_type/service_price_bloc.dart';
import 'package:home_clean/presentation/widgets/currency_display.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../domain/entities/building/building.dart';
import '../../../domain/entities/house/house.dart';
import '../../../domain/entities/order/create_order.dart';
import '../../blocs/building/building_bloc.dart';
import '../../blocs/building/building_event.dart';
import '../../blocs/house/house_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/service_in_house_type/service_price_event.dart';
import '../../blocs/service_in_house_type/service_price_state.dart';
import '../../blocs/transaction/transaction_event.dart';
import '../../blocs/transaction/transation_bloc.dart';
import '../../blocs/wallet/wallet_bloc.dart';
import '../../blocs/wallet/wallet_state.dart';
import '../../widgets/detail_row_widget.dart';
import '../../widgets/section_widget.dart';
import '../../widgets/show_dialog.dart';
import '../../widgets/step_indicator_widget.dart';
import 'components/transaction_pop_up.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final CreateOrder orderDetails;

  const OrderConfirmationScreen({
    super.key,
    required this.orderDetails,
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  String? selectedWalletId;
  bool _isOrdering = false;
  House? house;
  late StreamSubscription<OrderState> _stateSubscription;
   int priceOfHouseType = 0;
  Building? selectedBuilding;

  @override
  void initState() {
    super.initState();
    fetchHouse();
    context.read<BuildingBloc>().add(GetBuildings());
    _fetchPriceByHouseType();
    _calculateTotalPrice();
  }

  Future<void> _fetchPriceByHouseType() async {
    context.read<ServicePriceBloc>().add(
      GetServicePrice(
        houseId: house?.id ?? '',
        serviceId: widget.orderDetails.service.id ?? '',
      ),
    );
  }

  void _placeOrder(BuildContext context) {
    if (_isOrdering) return;
    setState(() => _isOrdering = true);
    context.read<OrderBloc>().add(CreateOrderEvent(widget.orderDetails));
    _stateSubscription =
        BlocProvider.of<OrderBloc>(context).stream.listen((state) {
      if (!mounted) {
        _stateSubscription.cancel();
        return;
      }
      if (state is OrderCreated) {
        setState(() => _isOrdering = false);
        _stateSubscription.cancel();
      } else if (state is OrderError) {
        setState(() => _isOrdering = false);
        _stateSubscription.cancel();
      }
    }, onError: (error) {
      if (!mounted) return;
      setState(() => _isOrdering = false);
    });
  }

  @override
  void dispose() {
    // Ensure the subscription is cancelled
    _stateSubscription.cancel();
    super.dispose();
  }

  void fetchHouse() {
    final houseBloc = context.read<HouseBloc>();
    house = houseBloc.cachedHouse;
    widget.orderDetails.address = house!.id.toString();
    widget.orderDetails.houseTypeId = house!.houseTypeId;
  }


  int _calculateTotalPrice() {
    int total = 0;

    // Add prices from additional options
    if (widget.orderDetails.option.isNotEmpty) {
      total += widget.orderDetails.option
          .map((option) => option.price ?? 0)
          .reduce((a, b) => a + b);
    }

    // Add prices from extra services
    if (widget.orderDetails.extraService.isNotEmpty) {
      total += widget.orderDetails.extraService
          .map((service) => service.price ?? 0)
          .reduce((a, b) => a + b);
    }

    // Add price of house type
    if (priceOfHouseType > 0) {
      total += priceOfHouseType;
    }

    if(widget.orderDetails.emergencyRequest) {
      total += 30000; // Add emergency request fee
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Xác nhận',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ServicePriceBloc, ServicePriceState>(
            listener: (context, state) {
              if (state is ServicePriceLoaded) {
                setState(() {
                  priceOfHouseType = state.servicePrice.price ?? 0;
                });
              } else if (state is ServicePriceError) {
                showCustomDialog(
                  context: context,
                  message: 'Không thể tải giá dịch vụ: ${state.message}',
                  type: DialogType.error,
                );
              }
            },
          ),
          BlocListener<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderCreated) {
                context.read<TransactionBloc>().add(
                  SaveTransactionEvent(
                    CreateTransaction(
                      walletId: selectedWalletId,
                      paymentMethodId: '15890b1a-f5a6-42c3-8f37-541029189722',
                      amount: '0',
                      note: 'Thanh toán dịch vụ',
                      orderId: state.order.id,
                      serviceType: 0,
                    ),
                  ),
                );
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const TransactionPopup(),
                );
              } else if (state is OrderError) {
                showCustomDialog(
                  context: context,
                  message: state.message,
                  type: DialogType.error,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  StepIndicatorWidget(currentStep: 3),
                  const SizedBox(height: 8),
                  SectionWidget(
                    title: 'Chi tiết dịch vụ',
                    icon: Icons.cleaning_services_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailRowWidget(
                          title: 'Dịch vụ',
                          value: widget.orderDetails.service.name ??
                              'Dọn dẹp căn hộ',
                          icon: Icons.home_work_outlined,
                        ),
                        if (widget.orderDetails.emergencyRequest)
                          _buildEmergencyBadge(),
                        const SizedBox(height: 12),
                        DetailRowWidget(
                          title: 'Thời gian',
                          value:
                          '${widget.orderDetails.timeSlot.startTime} - ${widget.orderDetails.timeSlot.endTime}',
                          icon: Icons.access_time,
                        ),
                      ],
                    ),
                  ),
                  if (widget.orderDetails.option.isNotEmpty)
                    SectionWidget(
                      title: 'Tùy chọn đã chọn',
                      icon: Icons.checklist_outlined,
                      child: Column(
                        children: widget.orderDetails.option
                            .map(
                              (option) => _buildOptionItem(
                            title: option.name ?? '',
                            price: option.price ?? 0,
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  if (widget.orderDetails.extraService.isNotEmpty)
                    SectionWidget(
                      title: 'Dịch vụ thêm',
                      icon: Icons.add_circle_outline,
                      child: Column(
                        children: widget.orderDetails.extraService
                            .map(
                              (service) => _buildOptionItem(
                            title: service.name ?? '',
                            price: service.price ?? 0,
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  SectionWidget(
                    title: 'Chi phí dịch vụ',
                    icon: Icons.calculate,
                    child: _buildOptionItem(
                      title: 'Tổng tiền',
                      price: _calculateTotalPrice(),
                    ),
                  ),
                  _buildWallet(context),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildWallet(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        if (state is WalletLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
              strokeWidth: 3,
            ),
          );
        } else if (state is WalletLoaded) {
          return SectionWidget(
            title: 'Chọn ví thanh toán',
            icon: Icons.account_balance_wallet_outlined,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.wallets.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final wallet = state.wallets[index];
                  final isSelected = wallet.id == selectedWalletId;
                  final walletTitle = wallet.type == WalletType.personal
                      ? '${wallet.type} (Ví riêng)'
                      : wallet.type;

                  return _buildPaymentOption(
                    title: walletTitle ?? '',
                    balance: wallet.balance ?? 0,
                    icon: Icons.account_balance,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        selectedWalletId = wallet.id;
                      });
                    },
                  );
                },
              ),
            ),
          );
        } else if (state is WalletError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  "Lỗi: ${state.message}",
                  style: GoogleFonts.poppins(
                    color: Colors.red[700],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet_outlined,
                  size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "Không có dữ liệu ví",
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required int balance,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Hero(
      tag: 'wallet_$title',
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor.withAlpha(8)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withAlpha(1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: !isSelected
                          ? AppColors.primaryColor.withAlpha(1)
                          : Colors.green.withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.green[700]
                                : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        CurrencyDisplay(
                          price: balance,
                          fontSize: 14,
                          iconSize: 16,
                          unit: '',
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha((0.1 * 255).toInt()),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyBadge() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flash_on, size: 16, color: Colors.red[700]),
          const SizedBox(width: 4),
          Text(
            'Dịch vụ siêu tốc: ',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.red[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          CurrencyDisplay(price: 30000)
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required String title,
    required int price,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
          CurrencyDisplay(
            price: price,
            fontSize: 14,
            iconSize: 16,
            unit: '',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: (_isOrdering || selectedWalletId == null)
              ? null
              : () => _placeOrder(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: (_isOrdering || selectedWalletId == null)
                ? Colors.grey
                : const Color(0xFF1CAF7D),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            _isOrdering
                ? 'Đang đặt hàng...'
                : (selectedWalletId == null
                    ? 'Vui lòng chọn ví'
                    : 'Xác nhận đặt dịch vụ'),
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
