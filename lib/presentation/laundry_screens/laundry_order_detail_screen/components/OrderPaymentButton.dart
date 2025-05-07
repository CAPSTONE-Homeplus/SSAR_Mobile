import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/router/app_router.dart';

import '../../../../core/enums/laundry_order_status.dart';
import '../../../../domain/entities/transaction/create_transaction.dart';
import '../../../blocs/laundry_transaction_bloc/laundry_transaction_bloc.dart';
import '../../../blocs/laundry_transaction_bloc/laundry_transaction_event.dart';
import '../../../blocs/laundry_transaction_bloc/laundry_transaction_state.dart';
import '../../../widgets/show_dialog.dart';

class OrderPaymentButton extends StatelessWidget {
  final dynamic order;
  final String selectedWalletId;
  final VoidCallback? onSuccess;

  const OrderPaymentButton({
    Key? key,
    required this.order,
    required this.selectedWalletId,
    this.onSuccess,
  }) : super(key: key);

  void _showErrorDialog(BuildContext context) {
    showCustomDialog(
      context: context,
      message: 'Giao dịch thất bại',
      type: DialogType.error,
    );
  }

  void _handlePayment(BuildContext context) {
    context.read<LaundryTransactionBloc>().add(
          SaveLaundryTransactionEvent(
            CreateTransaction(
              walletId: selectedWalletId,
              paymentMethodId: 'b4fa2afa-f934-4eb8-8b74-27dd564f495f',
              amount: '0',
              note: 'Thanh toán dịch vụ',
              orderId: order.id,
              serviceType: 1,
            ),
          ),
        );
  }

  void _showSuccessDialog(BuildContext context) {
    showCustomDialog(
      context: context,
      message: 'Thanh toán thành công',
      type: DialogType.success,
      onConfirm: () {
        if (onSuccess != null) {
          onSuccess!();
        }
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF1CAF7D);

    return BlocConsumer<LaundryTransactionBloc, LaundryTransactionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        // Đóng tất cả dialog đang mở
        Navigator.of(context, rootNavigator: true)
            .popUntil((route) => route is! DialogRoute);

        switch (state.status) {
          case LaundryTransactionStatus.loading:
            _showLoadingDialog(context);
            break;
          case LaundryTransactionStatus.success:
            _showSuccessDialog(context);
            break;
          case LaundryTransactionStatus.failure:
            _showErrorDialog(context);
            break;
          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoading = state.status == LaundryTransactionStatus.loading;
        final isPendingPayment = order.status == 'PendingPayment';

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed:
                (isPendingPayment && selectedWalletId.isNotEmpty && !isLoading)
                    ? () {
                        if (selectedWalletId.isEmpty) {
                          showCustomDialog(
                            context: context,
                            message: 'Vui lòng chọn ví thanh toán',
                            type: DialogType.error,
                          );
                          return;
                        }
                        _handlePayment(context);
                      }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isPendingPayment
                  ? 'Thanh toán'
                  : LaundryOrderStatusExtension.fromString(
                order.status ?? '',
              ).name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
