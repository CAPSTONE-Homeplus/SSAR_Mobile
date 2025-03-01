import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'amount_chip.dart';

class SuggestedAmountsWidget extends StatelessWidget {
  final List<int> suggestedAmounts;
  final Function(int) onAmountSelected;
  final double fem;
  final double ffem;

  const SuggestedAmountsWidget({
    Key? key,
    required this.suggestedAmounts,
    required this.onAmountSelected, // Callback
    required this.fem,
    required this.ffem,
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
            'Số tiền phổ biến',
            style: GoogleFonts.poppins(
              fontSize: 14 * ffem,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 16 * fem),
          Wrap(
            spacing: 12 * fem,
            runSpacing: 12 * fem,
            children: suggestedAmounts
                .map((amount) => AmountChipWidget(
              amount,
              fem: fem,
              ffem: ffem,
              onAmountSelected: onAmountSelected,
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
