import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../blocs/transaction/transaction_state.dart';
import '../../../blocs/transaction/transation_bloc.dart';

class TransactionPopup extends StatelessWidget {
  // Color constants
  static const Color _primaryColor = Color(0xFF1CAF7D);
  static const Color _errorColor = Colors.red;
  static const Color _greyColor = Colors.grey;

  const TransactionPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is CleaningTransactionSuccess) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context, rootNavigator: true).pop();
            AppRouter.navigateToOrderDetailWithArguments(state.transaction.orderId ?? "");
          });
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(state),
                const SizedBox(height: 16),
                _buildContent(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(TransactionState state) {
    String title = "Xử lý giao dịch...";
    Color titleColor = Colors.black87;

    if (state is CleaningTransactionFailure) {
      title = "Giao dịch thất bại";
      titleColor = _errorColor;
    }

    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: titleColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContent(BuildContext context, TransactionState state) {
    if (state is CleaningTransactionFailure) {
      return _buildFailureContent(context, state);
    }

    return _buildLoadingContent();
  }

  Widget _buildFailureContent(BuildContext context, CleaningTransactionFailure state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          color: _errorColor,
          size: 64,
        ),
        const SizedBox(height: 12),
        Text(
          "Số dư không đủ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _errorColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          state.error,
          style: TextStyle(
            color: _greyColor,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: _primaryColor,
          ),
        ),
        SizedBox(width: 10),
        Text(
          "Đang xử lý...",
          style: TextStyle(
            fontSize: 16,
            color: _greyColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              AppRouter.navigateToPayment();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Nạp tiền",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: _primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Đóng",
              style: TextStyle(
                fontSize: 16,
                color: _primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}