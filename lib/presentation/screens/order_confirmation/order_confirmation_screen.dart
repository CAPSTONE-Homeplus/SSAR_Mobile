import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/core/enums/wallet_enums.dart';
import 'package:home_clean/core/format/validation.dart';
import 'package:home_clean/domain/entities/transaction/create_transaction.dart';
import 'package:home_clean/presentation/widgets/address_bottom_sheet.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../domain/entities/order/create_order.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/transaction/transaction_event.dart';
import '../../blocs/transaction/transaction_state.dart';
import '../../blocs/transaction/transation_bloc.dart';
import '../../blocs/wallet/wallet_bloc.dart';
import '../../blocs/wallet/wallet_state.dart';
import '../../widgets/step_indicator_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    String selectedBuilding = '';
    String selectedRoom = '';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Xác nhận',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
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
                ),
              ),
            );
            _showTransactionPopup(context);
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                StepIndicatorWidget(currentStep: 3),
                const SizedBox(height: 8),
                _buildSection(
                  title: 'Địa chỉ',
                  icon: Icons.location_on_outlined,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => AddressBottomSheet(
                          currentAddress: widget.orderDetails.address,
                          currentBuilding: selectedBuilding,
                          currentRoom: selectedRoom,
                          onAddressSelected: (address, building, room) {
                            setState(() {
                              widget.orderDetails.address = address;
                              selectedBuilding = building;
                              selectedRoom = room;
                            });
                          },
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.orderDetails.address,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (selectedBuilding.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Tòa: $selectedBuilding',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),

                _buildSection(
                  title: 'Chi tiết dịch vụ',
                  icon: Icons.cleaning_services_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        title: 'Dịch vụ',
                        value: widget.orderDetails.service.name ?? 'Dọn dẹp căn hộ',
                        icon: Icons.home_work_outlined,
                      ),
                      if (widget.orderDetails.emergencyRequest) _buildEmergencyBadge(),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        title: 'Thời gian',
                        value:
                        '${widget.orderDetails.timeSlot.startTime} - ${widget.orderDetails.timeSlot.endTime}',
                        icon: Icons.access_time,
                      ),
                    ],
                  ),
                ),

                if (widget.orderDetails.option.isNotEmpty)
                  _buildSection(
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
                  _buildSection(
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
                _buildWallet( context),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
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
          return _buildSection(
            title: 'Chọn ví thanh toán',
            icon: Icons.account_balance_wallet_outlined,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.wallets.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
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
                color: isSelected ? AppColors.primaryColor.withAlpha(8) : Colors.white,
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
                      color: isSelected ? AppColors.primaryColor : Colors.grey[700],
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
                            color: isSelected ? Colors.green[700] : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${Validation.formatCurrency(balance)} đ',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.green[600] : Colors.grey[600],
                          ),
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



  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF1CAF7D), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flash_on, size: 16, color: Colors.red[700]),
          const SizedBox(width: 4),
          Text(
            'Dịch vụ siêu tốc',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.red[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocConsumer<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Thanh toán thành công!")),
              );
            } else if (state is TransactionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Thanh toán thất bại!")),
              );
            }
          },
          builder: (context, state) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Xử lý giao dịch...",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    state is TransactionLoading
                        ? const CircularProgressIndicator()
                        : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Giao dịch thất bại. Vui lòng thử lại!"),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Đóng"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
          Text(
            Validation.formatCurrency(price),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1CAF7D),
            ),
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
          onPressed: () {
            context.read<OrderBloc>().add(CreateOrderEvent(widget.orderDetails));

            BlocListener<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is OrderCreated) {
                  print("Đặt hàng thành công!");
                } else if (state is OrderError) {
                  print("Lỗi đặt hàng: ${state}");
                }
              },
              child: ElevatedButton(
                onPressed: () {
                  context.read<OrderBloc>().add(CreateOrderEvent(widget.orderDetails));
                },
                child: Text("Đặt hàng"),
              ),
            );

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1CAF7D),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'Xác nhận đặt dịch vụ',
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
