import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentOption extends StatelessWidget {
  final String value;
  final String title;
  final String selectedPaymentId;
  final Function(String) onSelect;
  final double fem;
  final double ffem;

  const PaymentOption({
    Key? key,
    required this.value,
    required this.title,
    required this.selectedPaymentId,
    required this.onSelect,
    required this.fem,
    required this.ffem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedPaymentId == value;

    return InkWell(
      onTap: () => onSelect(value),
      borderRadius: BorderRadius.circular(12 * fem),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16 * fem,
          vertical: 14 * fem,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1CAF7D).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12 * fem),
          border: Border.all(
            color: isSelected ? const Color(0xFF1CAF7D) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Hiển thị biểu tượng thanh toán
            Container(
              width: 40 * fem,
              height: 40 * fem,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8 * fem),
              ),
              child: Image.asset(
                title == 'VNPay' ? 'assets/icons/vnpay.jpg' :
                title == 'Paypal' ? 'assets/icons/paypal.png' :
                'assets/icons/default_wallet.jpg',
                width: 20 * fem,
                height: 20 * fem,
              ),
            ),
            SizedBox(width: 16 * fem),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14 * ffem,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Radio(
              value: value,
              groupValue: selectedPaymentId,
              activeColor: const Color(0xFF1CAF7D),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onSelect(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
