import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletHeaderWidget extends StatelessWidget {
  final VoidCallback onAddPoints;
  final double fem;

  const WalletHeaderWidget({
    Key? key,
    required this.onAddPoints,
    required this.fem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8 * fem),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 18 * fem,
              ),
            ),
            SizedBox(width: 10 * fem),
            Text(
              'Ví của tôi',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16 * fem,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: onAddPoints,
          borderRadius: BorderRadius.circular(8 * fem),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8 * fem, horizontal: 12 * fem),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(8 * fem),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Nạp điểm',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12 * fem,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6 * fem),
                Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 16 * fem,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
