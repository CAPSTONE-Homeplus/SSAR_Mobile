import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/format/formater.dart';
import '../../../../../domain/entities/wallet/wallet.dart';

class WalletCardWidget extends StatelessWidget {
  final int index;
  final List<Wallet> walletUserList;
  final double fem;
  final VoidCallback? onTap;

  const WalletCardWidget({
    super.key,
    required this.index,
    required this.walletUserList,
    required this.fem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final wallet = walletUserList[index];
    final isPersonal = wallet.type == 'Personal';
    final isSingleWallet = walletUserList.length == 1;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isSingleWallet ? double.infinity : double.infinity,
        height: isSingleWallet ? 110 * fem : null,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12 * fem),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isSingleWallet ? 18 * fem : 16 * fem,
          vertical: isSingleWallet ? 16 * fem : 16 * fem,
        ),
        child: isSingleWallet
            ? _buildSingleWalletLayout(wallet, isPersonal, context)
            : _buildMultiWalletLayout(wallet, isPersonal),
      ),
    );
  }

  Widget _buildSingleWalletLayout(
      Wallet wallet, bool isPersonal, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12 * fem),
                  decoration: BoxDecoration(
                    color: isPersonal
                        ? Colors.orange.withOpacity(0.3)
                        : Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8 * fem),
                  ),
                  child: Icon(
                    isPersonal ? Icons.account_circle : Icons.people,
                    color: isPersonal ? Colors.orange[200] : Colors.blue[200],
                    size: 16 * fem,
                  ),
                ),
                SizedBox(width: 8 * fem),
                Text(
                  isPersonal ? 'Ví cá nhân' : 'Ví chung',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14 * fem,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 8 * fem,
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Số điểm hiện tại',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12 * fem,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4 * fem),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 6 * fem),
                  child: Icon(
                    Icons.stars,
                    color: Colors.amber,
                    size: 24 * fem,
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 150 * fem),
                  child: Text(
                    Formater.formatCurrency(
                        wallet.balance != null ? wallet.balance!.round() : 0),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24 * fem,
                      fontWeight: FontWeight.bold,
                      height: 1,
                      letterSpacing: -0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMultiWalletLayout(Wallet wallet, bool isPersonal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(5 * fem),
              decoration: BoxDecoration(
                color: isPersonal
                    ? Colors.orange.withOpacity(0.3)
                    : Colors.blue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6 * fem),
              ),
              child: Icon(
                isPersonal ? Icons.account_circle : Icons.people,
                color: isPersonal ? Colors.orange[200] : Colors.blue[200],
                size: 14 * fem,
              ),
            ),
            SizedBox(width: 6 * fem),
            Expanded(
              child: Text(
                isPersonal ? 'Ví cá nhân' : 'Ví chung',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12 * fem,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.7),
              size: 12 * fem,
            ),
          ],
        ),
        SizedBox(height: 10 * fem),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 6 * fem),
              child: Icon(
                Icons.stars,
                color: Colors.amber,
                size: 20 * fem,
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 100 * fem),
              child: Text(
                Formater.formatCurrency(
                    wallet.balance != null ? wallet.balance!.round() : 0),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14 * fem,
                  fontWeight: FontWeight.bold,
                  height: 1,
                  letterSpacing: -0.5,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
