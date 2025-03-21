import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/domain/entities/contribution_statistics/contribution_statistics.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_event.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../../blocs/wallet/wallet_bloc.dart';
import '../../../../blocs/wallet/wallet_state.dart';

class SpendingScreen extends StatefulWidget {
  const SpendingScreen({Key? key}) : super(key: key);

  @override
  State<SpendingScreen> createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> with SingleTickerProviderStateMixin {
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

  void _initData() {
    context.read<SharedWalletBloc>().add(GetSharedWallet());
  }

  void _reloadData() {
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
      appBar: CustomAppBar(
          title: 'Chi tiêu',
          onBackPressed: () => Navigator.pop(context)
      ),
      body: MultiBlocListener(
        listeners: [
          // SharedWalletBloc Listener
          BlocListener<SharedWalletBloc, WalletState>(
            listener: (context, state) {
              if (state is SharedWalletLoaded) {
                final walletId = state.wallets.isNotEmpty ? state.wallets.first.id : '';
                if (walletId != null && walletId.isNotEmpty) {
                  // Dispatch contribution statistics event
                  context.read<WalletBloc>().add(
                      GetContributionStatistics(
                          walletId: walletId,
                          days: days
                      )
                  );
                }
              }
            },
          ),
          // WalletBloc Listener for handling errors and specific states
          BlocListener<SharedWalletBloc, WalletState>(
            listener: (context, state) {
              if (state is WalletError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message ?? 'Đã xảy ra lỗi',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            // Period Selection Container
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
                              });
                              // Reload data with new time period
                              _reloadData();
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

            // Contribution Statistics Content
            Expanded(
              child: BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  // Handle different states with more robust logic
                  if (state is WalletLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  if (state is WalletContributionStatisticsLoaded) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _buildContributionTab(fem, state.contributionStatistics),
                      ],
                    );
                  }

                  if (state is SharedWalletLoaded) {
                    // If we have no statistics yet but have the wallet, show a loading indicator
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  // Handle error or empty state
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.grey,
                          size: 60 * fem,
                        ),
                        SizedBox(height: 16 * fem),
                        Text(
                          'Không có dữ liệu',
                          style: GoogleFonts.poppins(
                            fontSize: 16 * fem,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 16 * fem),
                        ElevatedButton(
                          onPressed: _reloadData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          child: Text(
                            'Thử lại',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
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
          // Tổng quan đóng góp
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
                    'Tổng tiền góp quỹ ${statistics.timeFrame ?? ''}',
                    style: GoogleFonts.poppins(
                      fontSize: 16 * fem,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${statistics.totalContribution?.toStringAsFixed(0) ?? '0'} VNĐ',
                    style: GoogleFonts.poppins(
                      fontSize: 20 * fem,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24 * fem),

          // Tiêu đề danh sách đóng góp
          Text(
            'Đóng góp theo thành viên',
            style: GoogleFonts.poppins(
              fontSize: 16 * fem,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12 * fem),

          if (statistics.members != null && statistics.members!.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statistics.members!.length,
              separatorBuilder: (context, index) => SizedBox(height: 8 * fem),
              itemBuilder: (context, index) {
                final member = statistics.members![index];
                return _buildContributionListItem(
                  fem: fem,
                  member: member,
                  color: memberColors[index % memberColors.length],
                );
              },
            )
          else
            Center(
              child: Text(
                'Không có dữ liệu đóng góp',
                style: GoogleFonts.poppins(
                  fontSize: 14 * fem,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContributionListItem({
    required double fem,
    required Members member,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12 * fem),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16 * fem,
          vertical: 8 * fem,
        ),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.person, color: color),
        ),
        title: Text(
          member.name ?? 'Thành viên',
          style: GoogleFonts.poppins(
            fontSize: 16 * fem,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4 * fem),
            Text(
              '${member.contribution?.toStringAsFixed(0) ?? '0'} VNĐ',
              style: GoogleFonts.poppins(
                fontSize: 14 * fem,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4 * fem),
            LinearProgressIndicator(
              value: (member.percentage ?? 0) / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6 * fem,
            ),
            SizedBox(height: 4 * fem),
            Text(
              '${member.percentage ?? 0}%',
              style: GoogleFonts.poppins(
                fontSize: 12 * fem,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}