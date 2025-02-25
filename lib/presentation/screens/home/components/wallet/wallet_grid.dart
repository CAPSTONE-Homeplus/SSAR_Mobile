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
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12 * fem,
        mainAxisSpacing: 12 * fem,
        childAspectRatio: 1.5,
      ),
      itemCount: walletUserList.length,
      itemBuilder: (context, index) => WalletCardWidget(index: index, walletUserList: walletUserList, fem: fem),
    );
  }
}
