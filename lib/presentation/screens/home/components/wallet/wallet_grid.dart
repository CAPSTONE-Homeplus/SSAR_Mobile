import 'package:flutter/cupertino.dart';
import 'package:home_clean/presentation/screens/home/components/wallet/wallet_card.dart';

import '../../../../../domain/entities/wallet/wallet.dart';

class WalletGridWidget extends StatelessWidget {
  final List<Wallet> walletUserList;
  final double fem;

  const WalletGridWidget({
    Key? key,
    required this.walletUserList,
    required this.fem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int indexWallet = walletUserList.length;
    bool isSingleWallet = indexWallet == 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isSingleWallet ? 1 : 2,
        crossAxisSpacing: isSingleWallet ? 0 : 12 * fem,
        mainAxisSpacing: isSingleWallet ? 0 : 12 * fem,
        childAspectRatio: isSingleWallet ? 2 : 1.5,
      ),
      itemCount: indexWallet,
      itemBuilder: (context, index) => WalletCardWidget(
        index: index,
        walletUserList: walletUserList,
        fem: fem,
      ),
    );
  }

}
