import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/format/validation.dart';
import '../../../../../domain/entities/wallet/wallet.dart';

class WalletCardWidget extends StatelessWidget {
  final int index;
  final List<Wallet> walletUserList;
  final double fem;

  const WalletCardWidget({
    Key? key,
    required this.index,
    required this.walletUserList,
    required this.fem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wallet = walletUserList[index];
    final isPersonal = wallet.type == 'Personal';

    return Container(
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
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(14 * fem),
      child: Column(
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
            ],
          ),
          SizedBox(height: 10 * fem),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 100 * fem),
                child: Text(
                  Validation.formatCurrency(wallet.balance ?? 0),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18 * fem,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 4 * fem),
              Padding(
                padding: EdgeInsets.only(bottom: 2 * fem),
                child: Icon(
                  Icons.brightness_1,
                  color: isPersonal ? Colors.amber[300] : Colors.greenAccent[200],
                  size: 8 * fem,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
