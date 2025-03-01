import 'package:flutter/cupertino.dart';
import 'package:home_clean/presentation/screens/home/components/wallet/wallet_grid.dart';
import 'package:home_clean/presentation/screens/home/components/wallet/wallet_header.dart';

import '../../../../../domain/entities/wallet/wallet.dart';
import 'create_wallet_button.dart';

class WalletContainer extends StatelessWidget {
  final List<Wallet> walletUserList;
  final VoidCallback onAddPoints;
  final double fem;
  final double ffem;

  const WalletContainer({
    Key? key,
    required this.walletUserList,
    required this.onAddPoints,
    this.fem = 1.0,
    this.ffem = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16 * fem),
      padding: EdgeInsets.all(20 * fem),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1CAF7D),
            Color(0xFF158F66),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16 * fem),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1CAF7D).withValues(alpha: (0.3 * 255).toDouble()),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WalletHeaderWidget(onAddPoints: onAddPoints, fem: fem),
          SizedBox(height: 16 * fem),
          WalletGridWidget(walletUserList: walletUserList, fem: fem),
            if (walletUserList.length < 2) ...[
            SizedBox(height: 14 * fem),
            CreateWalletButtonWidget(fem: fem),
          ],
        ],
      ),
    );
  }
}