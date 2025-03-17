import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/domain/entities/contribution_statistics/contribution_statistics.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_event.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../../../domain/entities/user/user.dart';
import '../../../../blocs/wallet/wallet_bloc.dart';
import '../../../../blocs/wallet/wallet_state.dart';

class SpendingScreen extends StatefulWidget {
  const SpendingScreen({Key? key}) : super(key: key);

  @override
  State<SpendingScreen> createState() => _SpendingScreenScreenState();
}

class _SpendingScreenScreenState extends State<SpendingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, int> _periods = {
    'Hôm nay': 1,
    'Tuần này': 7,
    'Tháng này': 30,
  };
  String _selectedPeriod = 'Hôm nay';
  int days = 1;

  // Define colors for member contributions
  final List<Color> memberColors = [
    Colors.blue[400]!,
    Colors.purple[400]!,
    Colors.orange[400]!,
    Colors.green[400]!,
    Colors.red[400]!,
    Colors.teal[400]!,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initData();
  }

  void _initData() async {
    context.read<SharedWalletBloc>().add(GetSharedWallet());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double fem = MediaQuery.of(context).size.width / 375;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: 'Chi tiêu', onBackPressed: () {
        Navigator.pop(context);
      }),
      body: BlocListener<SharedWalletBloc, WalletState>(
        listener: (context, state) {
          if (state is SharedWalletLoaded) {
            final walletId = state.wallets.isNotEmpty ? state.wallets.first.id : '';
            if (walletId != null && walletId.isNotEmpty) {
              context.read<WalletBloc>().add(GetContributionStatistics(walletId: walletId, days: days));
            }
          }
        },
        child: Column(
          children: [
            Container(
              color: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 16 * fem, vertical: 12 * fem),
              child: Row(
                children: [
                  Text(
                    'Thời gian:',
                    style: GoogleFonts.poppins(
                      fontSize: 14 * fem,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12 * fem, vertical: 6 * fem),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8 * fem),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPeriod,
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                          dropdownColor: AppColors.primaryColor,
                          style: GoogleFonts.poppins(
                            fontSize: 14 * fem,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedPeriod = newValue;
                                days = _periods[newValue] ?? 30;

                                // Reload data with new time period
                                context.read<SharedWalletBloc>().add(GetSharedWallet());
                              });
                            }
                          },
                          items: _periods.keys.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (state is WalletLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WalletContributionStatisticsLoaded) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _buildContributionTab(fem, state.contributionStatistics),
                      ],
                    );
                  } else if (state is SharedWalletLoaded) {
                    // If we have no statistics yet but have the wallet, show a loading indicator
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                      child: Text(
                        'Không có dữ liệu',
                        style: GoogleFonts.poppins(
                          fontSize: 16 * fem,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContributionTab(double fem, ContributionStatistics statistics) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16 * fem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16 * fem),
            ),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16 * fem),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tổng tiền góp quỹ',
                    style: GoogleFonts.poppins(
                      fontSize: 16 * fem,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   // '${totalContribution.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                  //   style: GoogleFonts.poppins(
                  //     fontSize: 24 * fem,
                  //     fontWeight: FontWeight.w700,
                  //     color: const Color(0xFF4CAF50),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24 * fem),

          // Bar chart title
          Text(
            'Góp quỹ theo thành viên',
            style: GoogleFonts.poppins(
              fontSize: 16 * fem,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16 * fem),

          // Show message if no contributions
          // if (contributions.isEmpty)
          //   Center(
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(vertical: 24 * fem),
          //       child: Text(
          //         'Chưa có đóng góp nào trong khoảng thời gian này',
          //         style: GoogleFonts.poppins(
          //           fontSize: 14 * fem,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.grey[600],
          //         ),
          //         textAlign: TextAlign.center,
          //       ),
          //     ),
          //   ),

          // // Bar chart cards
          // ...contributions.map((contribution) {
          //   final double percentage = totalContribution > 0
          //       ? (contribution['amount'] / totalContribution) * 100
          //       : 0;
          //
          //   return Container(
          //     margin: EdgeInsets.only(bottom: 12 * fem),
          //     padding: EdgeInsets.all(16 * fem),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(12 * fem),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.05),
          //           blurRadius: 4,
          //           offset: const Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Expanded(
          //               child: Text(
          //                 contribution['name'],
          //                 style: GoogleFonts.poppins(
          //                   fontSize: 14 * fem,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //             ),
          //             Text(
          //               '${percentage.toStringAsFixed(1)}%',
          //               style: GoogleFonts.poppins(
          //                 fontSize: 14 * fem,
          //                 fontWeight: FontWeight.w600,
          //                 color: contribution['color'],
          //               ),
          //             ),
          //           ],
          //         ),
          //         SizedBox(height: 8 * fem),
          //         Stack(
          //           children: [
          //             Container(
          //               height: 12 * fem,
          //               width: double.infinity,
          //               decoration: BoxDecoration(
          //                 color: Colors.grey[200],
          //                 borderRadius: BorderRadius.circular(6 * fem),
          //               ),
          //             ),
          //             Container(
          //               height: 12 * fem,
          //               width: totalContribution > 0
          //                   ? (MediaQuery.of(context).size.width - 64 * fem) * (percentage / 100)
          //                   : 0,
          //               decoration: BoxDecoration(
          //                 color: contribution['color'],
          //                 borderRadius: BorderRadius.circular(6 * fem),
          //               ),
          //             ),
          //           ],
          //         ),
          //         SizedBox(height: 8 * fem),
          //         Text(
          //           '${contribution['amount'].toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
          //           style: GoogleFonts.poppins(
          //             fontSize: 16 * fem,
          //             fontWeight: FontWeight.w600,
          //             color: const Color(0xFF4CAF50),
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // }).toList(),

          SizedBox(height: 24 * fem),

          // Recent contributions title
          Text(
            'Đóng góp gần đây',
            style: GoogleFonts.poppins(
              fontSize: 16 * fem,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12 * fem),

          // Show message if no recent contributions
          // if (contributions.isEmpty)
          //   Center(
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(vertical: 24 * fem),
          //       child: Text(
          //         'Chưa có đóng góp gần đây',
          //         style: GoogleFonts.poppins(
          //           fontSize: 14 * fem,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.grey[600],
          //         ),
          //         textAlign: TextAlign.center,
          //       ),
          //     ),
          //   ),
          //
          // // Recent contributions list
          // if (contributions.isNotEmpty)
          //   ListView.builder(
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: contributions.length,
          //     itemBuilder: (context, index) {
          //       final contribution = contributions[index];
          //       final User? user = contribution['user'];
          //       final String date = contribution['date'] != null
          //           ? _formatDate(contribution['date'])
          //           : 'Không có dữ liệu';
          //
          //       return Card(
          //         margin: EdgeInsets.only(bottom: 8 * fem),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(12 * fem),
          //         ),
          //         child: ListTile(
          //           title: Text(
          //             user?.fullName ?? 'Người dùng',
          //             style: GoogleFonts.poppins(
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //           subtitle: Text(
          //             date,
          //             style: GoogleFonts.poppins(
          //               fontSize: 12 * fem,
          //               color: Colors.grey[600],
          //             ),
          //           ),
          //           trailing: Text(
          //             '${contribution['contribution'].toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
          //             style: GoogleFonts.poppins(
          //               fontWeight: FontWeight.w600,
          //               color: const Color(0xFF4CAF50),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
        ],
      ),
    );
  }


  // Helper method to format date
  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Không xác định';
    }
  }
}