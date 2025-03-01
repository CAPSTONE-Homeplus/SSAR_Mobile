import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
class AmountChipWidget extends StatelessWidget {
  final int amount;
  final double fem;
  final double ffem;
  final Function(int) onAmountSelected; // Callback thay vì controller

  const AmountChipWidget(
      this.amount, {
        Key? key,
        required this.fem,
        required this.ffem,
        required this.onAmountSelected,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedAmount = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    ).format(amount);

    return InkWell(
      onTap: () => onAmountSelected(amount), // Gửi số tiền lên trên
      borderRadius: BorderRadius.circular(8 * fem),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16 * fem,
          vertical: 10 * fem,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8 * fem),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          '$formattedAmount ₫',
          style: GoogleFonts.poppins(
            fontSize: 14 * ffem,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
