import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/core/enums/wallet_enums.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/domain/entities/transaction/create_transaction.dart';
import 'package:home_clean/domain/entities/wallet/wallet.dart';
import 'package:home_clean/presentation/blocs/service_in_house_type/service_price_bloc.dart';
import 'package:home_clean/presentation/widgets/currency_display.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../domain/entities/building/building.dart';
import '../../../domain/entities/house/house.dart';
import '../../../domain/entities/order/create_order.dart';
import '../../blocs/building/building_bloc.dart';
import '../../blocs/building/building_event.dart';
import '../../blocs/cleaning_transaction_bloc/cleaning_transaction_bloc.dart';
import '../../blocs/cleaning_transaction_bloc/cleaning_transaction_event.dart';
import '../../blocs/cleaning_transaction_bloc/cleaning_transaction_state.dart';
import '../../blocs/house/house_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/service_in_house_type/service_price_event.dart';
import '../../blocs/service_in_house_type/service_price_state.dart';
import '../../blocs/wallet/wallet_bloc.dart';
import '../../blocs/wallet/wallet_state.dart';
import '../../widgets/detail_row_widget.dart';
import '../../widgets/section_widget.dart';
import '../../widgets/show_dialog.dart';
import '../../widgets/step_indicator_widget.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final OrderConfirmationArguments arguments;

  const OrderConfirmationScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  String? selectedWalletId;
  House? house;
  int priceOfHouseType = 0;
  Building? selectedBuilding;
  late CreateOrder orderDetails = widget.arguments.createOrder;

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
            serviceId: orderDetails.service.id ?? '',
          ),
        );
  }

  Future<void> _setId(String id) async {
    selectedWalletId = id.toString();
  }

  void _placeOrder(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận thanh toán'),
        content: const Text(
          'Bạn có chắc chắn muốn thanh toán không?\n\n'
              'Nhân viên sẽ được sắp xếp để thực hiện đơn trong thời gian gần nhất.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Hủy', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
              _proceedWithOrder(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1CAF7D),
            ),
            child: const Text(
              'Xác nhận',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }


  void _handleOrderError(BuildContext context, OrderError state) {
    showCustomDialog(
        context: context,
        message: "Tạo đơn hàng thất bại. Vui lòng thử lại sau.",
        type: DialogType.error
    );
  }
  void _showTransactionDialog(BuildContext context, {
    required bool isSuccess,
    String? message,
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
              size: 32,
            ),
            SizedBox(width: 12),
            Text(
              isSuccess ? 'Thành công' : 'Lỗi',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: isSuccess ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        content: Text(
          message ?? (isSuccess
              ? 'Giao dịch đã được thực hiện thành công'
              : 'Đã có lỗi xảy ra trong quá trình giao dịch'),
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (onConfirm != null) {
                onConfirm();
              }
            },
            child: Text(
              'Xác nhận',
              style: GoogleFonts.poppins(
                color: isSuccess ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedWithOrder(BuildContext context) {
    if (widget.arguments.reOrderId != null && widget.arguments.staff != null) {
      context
          .read<OrderBloc>()
          .add(ReOrderEvent(orderDetails, widget.arguments.reOrderId!));
    } else {
      context.read<OrderBloc>().add(CreateOrderEvent(orderDetails));
    }
  }

  void _handleOrderCreated(BuildContext context, OrderCreated state) {
    final order = state.order;

    context.read<CleaningTransactionBloc>().add(
      SaveCleaningTransactionEvent(
        CreateTransaction(
          walletId: selectedWalletId,
          paymentMethodId: '15890b1a-f5a6-42c3-8f37-541029189722',
          amount: '${0}',
          note: 'Thanh toán dịch vụ',
          orderId: order.id,
          serviceType: 0,
        ),
      ),
    );
  }



  void fetchHouse() {
    final houseBloc = context.read<HouseBloc>();
    house = houseBloc.cachedHouse;
    orderDetails.address = house!.id.toString();
    orderDetails.houseTypeId = house!.houseTypeId;
  }

  int _calculateTotalPrice() {
    int total = 0;

    // Add prices from additional options
    if (orderDetails.option.isNotEmpty) {
      total += orderDetails.option
          .map((option) => option.price ?? 0)
          .reduce((a, b) => a + b);
    }

    // Add prices from extra services
    if (orderDetails.extraService.isNotEmpty) {
      total += orderDetails.extraService
          .map((service) => service.price ?? 0)
          .reduce((a, b) => a + b);
    }

    // Add price of house type
    if (priceOfHouseType > 0) {
      total += priceOfHouseType;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Xác nhận',
        onBackPressed: () {
          AppRouter.navigateToServiceDetail(orderDetails.service.id ?? '');
        },
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderCreated) {
                _handleOrderCreated(context, state);
              } else if (state is OrderError) {
                _handleOrderError(context, state);
              }
            },
          ),
          BlocListener<ServicePriceBloc, ServicePriceState>(
            listener: (context, state) {
              if (state is ServicePriceLoaded) {
                setState(() {
                  priceOfHouseType = state.servicePrice.price ?? 0;
                });
              } else if (state is ServicePriceError) {
                showCustomDialog(
                  context: context,
                  message: 'Dịch vụ không khả dụng',
                  type: DialogType.error,
                  onConfirm: () {
                    AppRouter.navigateToHome();
                  },
                );
              }
            },
          ),
          BlocListener<CleaningTransactionBloc, CleaningTransactionState>(
            listenWhen: (previous, current) {
              return previous.status != current.status;
            },
            listener: (context, state) {
              // In log ra trạng thái mới
              debugPrint('CleaningTransactionStatus: ${state.status}');
              debugPrint('Error message (nếu có): ${state.errorMessage}');
              debugPrint('Order ID (nếu có): ${state.data?.orderId}');

              Navigator.of(context, rootNavigator: true)
                  .popUntil((route) => route is! DialogRoute);

              switch (state.status) {
                case CleaningTransactionStatus.loading:
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                        strokeWidth: 3,
                      ),
                    ),
                  );
                case CleaningTransactionStatus.success:
                  _showTransactionDialog(
                    context,
                    isSuccess: true,
                    onConfirm: () {
                      AppRouter.navigateToOrderDetailWithArguments(
                        state.data?.orderId ?? '',
                      );
                    },
                  );
                  break;
                case CleaningTransactionStatus.failure:
                  _showTransactionDialog(
                    context,
                    isSuccess: false,
                    message: state.errorMessage ?? 'Giao dịch thất bại',
                  );
                  break;
                default:
                  break;
              }
            },
          )

        ],
        child: SingleChildScrollView(
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
                      value: orderDetails.service.name ?? 'Dọn dẹp căn hộ',
                      icon: Icons.home_work_outlined,
                    ),
                    const SizedBox(height: 12),
                    DetailRowWidget(
                      title: 'Thời gian',
                      value:
                          '${orderDetails.timeSlot.startTime} - ${orderDetails.timeSlot.endTime}',
                      icon: Icons.access_time,
                    ),
                    if (widget.arguments.staff != null)
                      DetailRowMultiInfoWidget(
                        title: 'Nhân viên thực hiện',
                        icon: Icons.person,
                        iconColor: Colors.blue,
                        verticalSpacing: 4,
                        values: [
                          {
                            'label': 'Tên',
                            'value': widget.arguments.staff?.fullName ?? 'Chưa có tên',
                          },
                          {
                            'label': 'Mã NV',
                            'value': widget.arguments.staff?.code ?? 'Chưa có mã',
                          },
                          {
                            'label': 'SĐT',
                            'value': widget.arguments.staff?.phoneNumber ?? 'Chưa có số điện thoại',
                          },
                        ],
                      ),

                  ],
                ),
              ),
              SectionWidget(
                  title: 'Chi phí dịch vụ',
                  icon: Icons.calculate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Các dịch vụ chọn thêm:',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (orderDetails.option.isEmpty &&
                          orderDetails.extraService.isEmpty)
                        Center(
                          child: const Text(
                            'Không có dịch vụ chọn thêm',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        )
                      else ...[
                        ...orderDetails.option.map(
                          (option) => _buildOptionItem(
                            title: option.name ?? '',
                            price: option.price ?? 0,
                          ),
                        ),
                        ...orderDetails.extraService.map(
                          (service) => _buildOptionItem(
                            title: service.name ?? '',
                            price: service.price ?? 0,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'Thành tiền:',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildOptionItem(
                        title: 'Giá dịch vụ',
                        price: priceOfHouseType,
                      ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                      Row(
                        children: [
                          Text(
                            'Tổng cộng:',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          CurrencyDisplay(
                            price: _calculateTotalPrice(),
                            fontSize: 16,
                            iconSize: 18,
                            unit: '',
                          ),
                        ],
                      ),
                    ],
                  )),
              _buildWallet(context),
              const SizedBox(height: 100),
            ],
          ),
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
                    balance: (wallet.balance ?? 0).toInt(),
                    icon: Icons.account_balance,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _setId(wallet.id ?? '');
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
                          title == 'Shared'
                              ? 'Ví chung'
                              : 'Ví riêng',
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
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, walletState) {
            final totalPayment = _calculateTotalPrice();

            final selectedWallet = walletState is WalletLoaded
                ? walletState.wallets.firstWhere(
                  (wallet) => wallet.id == selectedWalletId,
                  orElse: () =>Wallet(),
            )
                : null;

            final canPlaceOrder =
                selectedWalletId != null &&
                selectedWallet != null &&
                (selectedWallet.balance ?? 0) >= totalPayment;

            return ElevatedButton(
              onPressed: canPlaceOrder
                  ? () {
                if ((selectedWallet.balance ?? 0) < totalPayment) {
                  showCustomDialog(
                    context: context,
                    message: 'Số dư ví không đủ để thanh toán',
                    type: DialogType.error,
                  );
                  return;
                }
                _placeOrder(context);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canPlaceOrder
                    ? const Color(0xFF1CAF7D)
                    : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                _getButtonText(
                  selectedWalletId: selectedWalletId,
                  selectedWallet: selectedWallet,
                  totalPayment: totalPayment,
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  String _getButtonText({
    required String? selectedWalletId,
    required dynamic selectedWallet,
    required int totalPayment,
  }) {

    if (selectedWalletId == null) return 'Vui lòng chọn ví';

    if (selectedWallet == null) return 'Ví không hợp lệ';

    final walletBalance = selectedWallet.balance ?? 0;

    if (walletBalance < totalPayment) {
      return 'Số dư không đủ';
    }

    return 'Xác nhận đặt dịch vụ';
  }
}
