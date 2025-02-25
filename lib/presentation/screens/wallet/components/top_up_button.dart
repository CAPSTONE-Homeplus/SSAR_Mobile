import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/transaction/transaction_state.dart';
import '../../../blocs/transaction/transation_bloc.dart';
import '../../payment_screen/payment_screen.dart';

class TopUpButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final double fem;
  final double ffem;
  final Function() onProcess;

  const TopUpButtonWidget({
    Key? key,
    required this.formKey,
    required this.fem,
    required this.ffem,
    required this.onProcess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30 * fem),
      width: double.infinity,
      child: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) async {
          if (state is TransactionSuccess) {
            if (state.transaction.paymentUrl != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentWebView(
                    paymentUrl: state.transaction.paymentUrl!,
                  ),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onProcess();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1CAF7D),
              padding: EdgeInsets.symmetric(vertical: 16 * fem),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12 * fem),
              ),
              elevation: 0,
            ),
            child: state is TransactionLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
              'Xác nhận nạp tiền',
              style: GoogleFonts.poppins(
                fontSize: 16 * ffem,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
