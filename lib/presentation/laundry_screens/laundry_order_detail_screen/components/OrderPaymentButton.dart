import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/laundry_order_status.dart';
import '../../../../domain/entities/transaction/create_transaction.dart';
import '../../../blocs/transaction/transaction_event.dart';
import '../../../blocs/transaction/transaction_state.dart';
import '../../../blocs/transaction/transation_bloc.dart';
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

  void _showErrorDialog(BuildContext context, String error) {
    showCustomDialog(
      context: context,
      message: error,
      type: DialogType.error,
      onConfirm: () {},
    );
  }

  void _handlePayment(BuildContext context) {
    context.read<TransactionBloc>().add(
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF1CAF7D);

    return BlocConsumer<TransactionBloc, TransactionState>(
      listenWhen: (prev, curr) =>
          (curr is LaundryTransactionSuccess &&
              prev is! LaundryTransactionSuccess) ||
          (curr is LaundryTransactionFailure &&
              prev is! LaundryTransactionFailure),
      listener: (context, state) {
        if (state is LaundryTransactionSuccess) {
          onSuccess?.call();
        } else if (state is LaundryTransactionFailure) {
          _showErrorDialog(context, state.error);
        }
      },
      builder: (context, state) {
        final isLoading = state is LaundryTransactionLoading;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: (order.status == 'PendingPayment' && !isLoading)
                ? () => _handlePayment(context)
                : null,
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
                    order.status == 'PendingPayment'
                        ? 'Thanh toán'
                        : LaundryOrderStatusExtension.fromString(
                                order.status ?? '')
                            .name,
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
