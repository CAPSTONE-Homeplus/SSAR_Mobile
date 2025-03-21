import 'package:flutter/material.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/domain/entities/wallet/wallet.dart';

import '../../../../../../../core/constant/colors.dart';
import '../../../../../widgets/currency_display.dart';

class BalanceCard extends StatelessWidget {
  Wallet wallet;

  BalanceCard({Key? key, required this.wallet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CurrencyDisplay(price: wallet.balance ?? 0, fontSize: 24, iconSize: 32),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              AppRouter.navigateToPayment();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Nạp tiền'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}