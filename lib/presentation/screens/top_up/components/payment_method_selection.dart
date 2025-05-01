import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../domain/entities/payment_method/payment_method.dart';
import 'payment_option.dart';

class PaymentMethodSelection extends StatelessWidget {
  final List<PaymentMethod> paymentMethods;
  final String selectedPaymentId;
  final Function(String) onPaymentSelected;
  final double fem;
  final double ffem;
  final bool showError;

  const PaymentMethodSelection({
    Key? key,
    required this.paymentMethods,
    required this.selectedPaymentId,
    required this.onPaymentSelected,
    required this.fem,
    required this.ffem,
    required this.showError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20 * fem),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phương thức thanh toán',
            style: GoogleFonts.poppins(
              fontSize: 16 * ffem,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16 * fem),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) {
              final payment = paymentMethods[1];
              return PaymentOption(
                value: payment.id!,
                title: payment.name!,
                selectedPaymentId: selectedPaymentId,
                onSelect: onPaymentSelected,
                fem: fem,
                ffem: ffem,
              );
            },
          ),
          if (showError && selectedPaymentId.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8 * fem),
              child: Text(
                'Vui lòng chọn một phương thức thanh toán',
                style: GoogleFonts.poppins(
                  fontSize: 14 * ffem,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
