import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';

class SpendingScreen extends StatefulWidget {
  const SpendingScreen({Key? key}) : super(key: key);

  @override
  State<SpendingScreen> createState() => _SpendingScreenScreenState();
}

class _SpendingScreenScreenState extends State<SpendingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _periods = ['Tháng này', 'Quý này', 'Năm nay', 'Tất cả'];
  String _selectedPeriod = 'Tháng này';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      appBar: AppBar(
        title: Text(
          'Thống kê ví chung',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Column(
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
                            });
                          }
                        },
                        items: _periods.map<DropdownMenuItem<String>>((String value) {
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContributionTab(fem),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionTab(double fem) {
    // Sample data for bar chart
    final List<Map<String, dynamic>> contributions = [
      {'name': 'Nguyễn Văn A', 'amount': 1500000, 'color': Colors.blue[400]},
      {'name': 'Trần Thị B', 'amount': 1200000, 'color': Colors.purple[400]},
      {'name': 'Lê Văn C', 'amount': 900000, 'color': Colors.orange[400]},
      {'name': 'Phạm Thị D', 'amount': 700000, 'color': Colors.green[400]},
    ];

    final double totalContribution = contributions.fold(0, (sum, item) => sum + item['amount']);

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
                  Text(
                    '${totalContribution.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                    style: GoogleFonts.poppins(
                      fontSize: 24 * fem,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
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

          // Bar chart cards
          ...contributions.map((contribution) {
            final double percentage = (contribution['amount'] / totalContribution) * 100;
            return Container(
              margin: EdgeInsets.only(bottom: 12 * fem),
              padding: EdgeInsets.all(16 * fem),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12 * fem),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        contribution['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 14 * fem,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: GoogleFonts.poppins(
                          fontSize: 14 * fem,
                          fontWeight: FontWeight.w600,
                          color: contribution['color'],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8 * fem),
                  Stack(
                    children: [
                      Container(
                        height: 12 * fem,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(6 * fem),
                        ),
                      ),
                      Container(
                        height: 12 * fem,
                        width: (MediaQuery.of(context).size.width - 64 * fem) * (percentage / 100),
                        decoration: BoxDecoration(
                          color: contribution['color'],
                          borderRadius: BorderRadius.circular(6 * fem),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8 * fem),
                  Text(
                    '${contribution['amount'].toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                    style: GoogleFonts.poppins(
                      fontSize: 16 * fem,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          SizedBox(height: 24 * fem),

          // Recent contributions
          Text(
            'Đóng góp gần đây',
            style: GoogleFonts.poppins(
              fontSize: 16 * fem,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12 * fem),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: contributions.length,
            itemBuilder: (context, index) {
              final contribution = contributions[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8 * fem),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * fem),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: contribution['color']!.withOpacity(0.2),
                    child: Text(
                      contribution['name'].substring(0, 1),
                      style: GoogleFonts.poppins(
                        color: contribution['color'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  title: Text(
                    contribution['name'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Ngày ${15 - index}/02/2025',
                    style: GoogleFonts.poppins(
                      fontSize: 12 * fem,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Text(
                    '${contribution['amount'].toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}