import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/router/app_router.dart';

import '../../../../core/enums/laundry_order_status.dart';
import '../../../../domain/entities/transaction/create_transaction.dart';
import '../../../blocs/transaction/transaction_event.dart';
import '../../../blocs/transaction/transaction_state.dart';
import '../../../blocs/transaction/transation_bloc.dart';
import '../../../widgets/show_dialog.dart';

class OrderPaymentButton extends StatefulWidget {
  final dynamic order;
  final String selectedWalletId;
  final VoidCallback? onSuccess;

  const OrderPaymentButton({
    Key? key,
    required this.order,
    required this.selectedWalletId,
    this.onSuccess,
  }) : super(key: key);

  @override
  State<OrderPaymentButton> createState() => _OrderPaymentButtonState();
}

class _OrderPaymentButtonState extends State<OrderPaymentButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF1CAF7D);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is LaundryTransactionSuccess) {
            setState(() {
              isLoading = false;
            });

            widget.onSuccess?.call();
          } else if (state is LaundryTransactionLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is LaundryTransactionFailure) {
            setState(() {
              isLoading = false;
            });

            showCustomDialog(
              context: context,
              message: state.error,
              type: DialogType.error,
              onConfirm: () {
                Navigator.pop(context);
              },
              confirmButtonText: 'Đóng',
            );
          }
        },
        child: ElevatedButton(
          onPressed: (widget.order.status == 'PendingPayment' && !isLoading)
              ? () {
                  // Tạo và gửi sự kiện thanh toán
                  context.read<TransactionBloc>().add(
                        SaveLaundryTransactionEvent(
                          CreateTransaction(
                            walletId: widget.selectedWalletId,
                            paymentMethodId:
                                '15890b1a-f5a6-42c3-8f37-541029189722',
                            amount: '0',
                            note: 'Thanh toán dịch vụ',
                            orderId: widget.order.id,
                            serviceType: 1,
                          ),
                        ),
                      );
                }
              : null, // Các trạng thái khác hoặc đang loading sẽ disable nút
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  widget.order.status == 'PendingPayment'
                      ? 'Thanh toán'
                      : LaundryOrderStatusExtension.fromString(
                              widget.order.status ?? '')
                          .name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
