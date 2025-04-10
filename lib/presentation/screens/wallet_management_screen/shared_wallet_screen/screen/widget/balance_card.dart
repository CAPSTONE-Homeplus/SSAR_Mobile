import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/domain/entities/wallet/wallet.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_event.dart';
import 'package:intl/intl.dart';

import '../../../../../../../core/constant/colors.dart';
import '../../../../../blocs/wallet/wallet_state.dart';
import '../../../../../widgets/currency_display.dart';
import '../confirm_transfer_dialog.dart';

class BalanceCard extends StatelessWidget {
  Wallet sharedWallet;
  Wallet personalWallet;

  BalanceCard({Key? key, required this.sharedWallet, required this.personalWallet}) : super(key: key);

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
              CurrencyDisplay(price: sharedWallet.balance ?? 0, fontSize: 24, iconSize: 32),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _showContributeFundDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Góp Quỹ'),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context,
                Icons.receipt_long,
                'Chi tiêu',
                      () {
                        AppRouter.navigateToSpending();

                  }
              ),
              _buildActionButton(
                context,
                Icons.group,
                'Thành viên',
                    () {
                  AppRouter.navigateToMember();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _showContributeFundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Góp Quỹ',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[800],
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bạn muốn chuyển điểm như thế nào?',
                style: GoogleFonts.poppins(
                  color: Colors.blueGrey[700],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          AppRouter.navigateToPayment(
                          );
                        },
                        icon: Icon(
                          Icons.house,
                          color: Colors.green[700],
                        ),
                        label: Text(
                          'Nạp điểm',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[50],
                          foregroundColor: Colors.green[700],
                          minimumSize: Size(constraints.maxWidth / 2.5, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmTransferDialog(
                              sharedWallet: sharedWallet,
                              personalWallet: personalWallet,
                              title: 'Chuyển điểm từ ví riêng',
                              message: 'Bạn có chắc muốn chuyển điểm từ ví riêng sang ví chung không?',
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.transfer_within_a_station,
                          color: Colors.blue[700],
                        ),
                        label: Text(
                          'Chuyển điểm',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.blue[700],
                          minimumSize: Size(constraints.maxWidth / 2.5, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.white.withOpacity(0.3),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

}