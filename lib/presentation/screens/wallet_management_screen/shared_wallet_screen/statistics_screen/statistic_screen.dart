import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/domain/entities/contribution_statistics/contribution_statistics.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_event.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_state.dart';
import 'package:home_clean/presentation/widgets/currency_display.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

class SpendingScreen extends StatefulWidget {
  const SpendingScreen({Key? key}) : super(key: key);

  @override
  State<SpendingScreen> createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> {
  final Map<String, int> _periods = {
    'Hôm nay': 1,
    'Tuần này': 7,
    'Tháng này': 30,
  };
  String _selectedPeriod = 'Hôm nay';
  int days = 1;

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
    _loadInitialData();
  }

  void _loadInitialData() {
    context.read<SharedWalletBloc>().add(GetSharedWallet());
  }

  void _fetchStatistics(String walletId) {
    context.read<WalletBloc>().add(
          GetContributionStatistics(walletId: walletId, days: days),
        );
  }

  @override
  Widget build(BuildContext context) {
    final double fem = MediaQuery.of(context).size.width / 375;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Hoạt động đóng góp',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocConsumer<SharedWalletBloc, WalletState>(
        listener: (context, state) {
          if (state is SharedWalletLoaded && state.wallets.isNotEmpty) {
            final shared = state.wallets.firstWhere(
              (w) => w.type?.toLowerCase() == 'shared',
            );
            if (shared != null) {
              _fetchStatistics(shared.id!);
            }
          }
        },
        builder: (context, sharedState) {
          return Column(
            children: [
              _buildTimeSelector(fem),
              Expanded(
                child: BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, state) {
                    if (state is WalletLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is WalletContributionStatisticsLoaded) {
                      return _buildContributionTab(
                        fem,
                        state.contributionStatistics,
                      );
                    }

                    if (state is WalletError) {
                      return Center(child: Text('Lỗi: ${state.message}'));
                    }

                    return Center(
                      child: Text(
                        'Không có dữ liệu',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeSelector(double fem) {
    return Container(
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
              padding:
                  EdgeInsets.symmetric(horizontal: 12 * fem, vertical: 6 * fem),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8 * fem),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPeriod,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white),
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
                        days = _periods[newValue] ?? 1; // ✅ Safe fallback
                      });
                      _loadInitialData();
                    }
                  },
                  items: _periods.keys
                      .map(
                        (key) => DropdownMenuItem<String>(
                          value: key,
                          child: Text(key),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionTab(double fem, ContributionStatistics statistics) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16 * fem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đóng góp theo thành viên',
            style: GoogleFonts.poppins(
                fontSize: 16 * fem, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12 * fem),
          if (statistics.members != null && statistics.members!.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statistics.members!.length,
              separatorBuilder: (_, __) => SizedBox(height: 8 * fem),
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
                style: GoogleFonts.poppins(color: Colors.grey),
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
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16 * fem, vertical: 8 * fem),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.person, color: color),
        ),
        title: Text(
          member.name ?? 'Thành viên',
          style: GoogleFonts.poppins(
              fontSize: 16 * fem, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4 * fem),
            CurrencyDisplay(
              price: member.contribution ?? 0,
              fontSize: 14 * fem,
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
              '${member.percentage?.toStringAsFixed(2) ?? '0.00'}%',
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
