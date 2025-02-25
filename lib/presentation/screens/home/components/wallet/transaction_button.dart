import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionButtonWidget extends StatelessWidget {
  final double fem;

  const TransactionButtonWidget({
    Key? key,
    required this.fem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10 * fem),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12 * fem),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10 * fem),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                color: Colors.white,
                size: 16 * fem,
              ),
              SizedBox(width: 8 * fem),
              Text(
                'Lịch sử giao dịch',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14 * fem,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
