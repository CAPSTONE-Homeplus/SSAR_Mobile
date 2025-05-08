import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/router/app_router.dart';

import '../../../../blocs/wallet/wallet_bloc.dart';
import '../../../../blocs/wallet/wallet_event.dart';
import '../../../../blocs/wallet/wallet_state.dart';

class CreateWalletButtonWidget extends StatelessWidget {
  final double fem;

  const CreateWalletButtonWidget({
    Key? key,
    required this.fem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is WalletCreatedSuccess) {
          AppRouter.navigateToSharedWallet();
        } else if (state is WalletError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${state.message}')),
          );
        }
      },
      child: InkWell(
        onTap: () {
          _showCreateWalletModal(context);
        },
        borderRadius: BorderRadius.circular(10 * fem),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12 * fem),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10 * fem),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 16 * fem,
                ),
                SizedBox(width: 8 * fem),
                Text(
                  'Tạo ví chung',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14 * fem,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateWalletModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24 * fem),
            topRight: Radius.circular(24 * fem),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20 * fem),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40 * fem,
                    height: 4 * fem,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4 * fem),
                    ),
                  ),
                ),
                SizedBox(height: 20 * fem),

                Text(
                  'Tạo ví chung',
                  style: GoogleFonts.poppins(
                    fontSize: 20 * fem,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 16 * fem),

                Container(
                  padding: EdgeInsets.all(16 * fem),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12 * fem),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primaryColor,
                            size: 20 * fem,
                          ),
                          SizedBox(width: 8 * fem),
                          Text(
                            'Ví chung là gì?',
                            style: GoogleFonts.poppins(
                              fontSize: 16 * fem,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8 * fem),
                      Text(
                        'Ví chung là tính năng cho phép bạn quản lý chi tiêu chung với nhiều người. Bạn có thể theo dõi, phân chia chi phí và quản lý ngân sách chung một cách dễ dàng.',
                        style: GoogleFonts.poppins(
                          fontSize: 14 * fem,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12 * fem),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 18 * fem,
                          ),
                          SizedBox(width: 8 * fem),
                          Expanded(
                            child: Text(
                              'Mời thành viên tham gia ví chung',
                              style: GoogleFonts.poppins(
                                fontSize: 14 * fem,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8 * fem),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 18 * fem,
                          ),
                          SizedBox(width: 8 * fem),
                          Expanded(
                            child: Text(
                              'Theo dõi chi tiêu theo thời gian thực',
                              style: GoogleFonts.poppins(
                                fontSize: 14 * fem,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8 * fem),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 18 * fem,
                          ),
                          SizedBox(width: 8 * fem),
                          Expanded(
                            child: Text(
                              'Chúng tôi không chịu trách nhiệm đối với mục đích sử dụng ví chung của các thành viên.',
                              style: GoogleFonts.poppins(
                                fontSize: 14 * fem,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24 * fem),

                ElevatedButton(
                  onPressed: () {
                    context.read<WalletBloc>().add(
                      CreateWallet(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14 * fem),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12 * fem),
                    ),
                    elevation: 0,
                    minimumSize: Size(double.infinity, 50 * fem),
                  ),
                  child: Text(
                    'Tạo ví chung ngay',
                    style: GoogleFonts.poppins(
                      fontSize: 16 * fem,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10 * fem),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    padding: EdgeInsets.symmetric(vertical: 10 * fem),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12 * fem),
                    ),
                    minimumSize: Size(double.infinity, 50 * fem),
                  ),
                  child: Text(
                    'Hủy',
                    style: GoogleFonts.poppins(
                      fontSize: 14 * fem,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}