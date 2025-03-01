import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/format/formater.dart';
import '../../../../domain/entities/wallet/wallet.dart';

class WalletSummary extends StatelessWidget {
  final Wallet selectedWallet;
  final double fem;
  final double ffem;

  const WalletSummary({
    Key? key,
    required this.selectedWallet,
    required this.fem,
    required this.ffem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20 * fem),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50 * fem,
            height: 50 * fem,
            decoration: BoxDecoration(
              color: const Color(0xFF1CAF7D).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Color(0xFF1CAF7D),
              size: 24,
            ),
          ),
          SizedBox(width: 16 * fem),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng số dư hiện tại',
                  style: GoogleFonts.poppins(
                    fontSize: 14 * ffem,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4 * fem),
                Text(
                  '${Formater.formatCurrency(selectedWallet.balance!)} ₫',
                  style: GoogleFonts.poppins(
                    fontSize: 20 * ffem,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyWalletMessage extends StatelessWidget {
  final double fem;
  final double ffem;

  const EmptyWalletMessage({
    Key? key,
    required this.fem,
    required this.ffem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20 * fem),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Không có ví nào khả dụng',
          style: GoogleFonts.poppins(
            fontSize: 16 * ffem,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
