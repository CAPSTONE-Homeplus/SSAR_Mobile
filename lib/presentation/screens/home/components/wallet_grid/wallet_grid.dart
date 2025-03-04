import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/screens/home/components/service/service_item.dart';

import '../../../../../domain/entities/wallet/wallet.dart';


class WalletGrid extends StatelessWidget {
  final List<Wallet> wallets;
  final double fem;
  final double ffem;
  final double hem;

  const WalletGrid({
    Key? key,
    required this.wallets,
    required this.fem,
    required this.ffem,
    required this.hem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (wallets.isEmpty) {
      return Center(
        child: Text(
          'Không có ví nào',
          style: GoogleFonts.poppins(
            fontSize: 16 * ffem,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16 * fem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quản lý ví của mình',
                style: GoogleFonts.poppins(
                  fontSize: 18 * ffem,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12 * hem),
          SizedBox(
            height: wallets.length <= 4 ? 100 * hem : 150 * hem,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 4,
                crossAxisSpacing: 8 * fem,
                mainAxisSpacing: 8 * hem,
              ),
              itemCount: wallets.length,
              itemBuilder: (context, index) {
                final wallet = wallets[index];
                Color walletColor;
                IconData walletIcon;
                switch (wallet.type?.toLowerCase()) {
                  case 'personal':
                    walletColor = Colors.blue;
                    walletIcon = Icons.account_balance_wallet;
                    break;
                  case 'shared':
                    walletColor = Colors.green;
                    walletIcon = Icons.group;
                    break;
                  default:
                    walletColor = Colors.grey;
                    walletIcon = Icons.account_balance;
                }
                return ServiceItemWidget(
                  icon: walletIcon,
                  title: wallet.type == 'Shared' ? 'Ví chung' : 'Ví cá nhân',
                  color: walletColor,
                  onTap: () {
                    wallet.type == 'Shared'
                        ? AppRouter.navigateToSharedWallet()
                        : AppRouter.navigateToPersonalWallet();
                  },
                  fem: fem,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
