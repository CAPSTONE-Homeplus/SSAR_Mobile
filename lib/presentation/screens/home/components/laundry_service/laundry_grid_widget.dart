import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/presentation/screens/home/components/service/service_item.dart';

import '../../../../../core/router/app_router.dart';

class LaundryGridWidget extends StatelessWidget {
  final double fem;
  final double ffem;
  final double hem;
  final List<Map<String, dynamic>> laundryServices;

  const LaundryGridWidget({
    Key? key,
    required this.fem,
    required this.ffem,
    required this.hem,
    this.laundryServices = const [
      {"title": "Giặt Sấy", "icon": Icons.local_laundry_service, "color": Colors.blueAccent},
    ], // Nếu có nhiều dịch vụ, chỉ cần thêm vào đây
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16 * fem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dịch vụ giặt sấy',
            style: GoogleFonts.poppins(
              fontSize: 18 * ffem,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12 * hem),
          _buildSingleService(),
        ],
      ),
    );
  }

  /// Hiển thị khi chỉ có 1 dịch vụ, căn giữa
  Widget _buildSingleService() {
    return Container(
      margin: EdgeInsets.only(left: 32 * fem),
      child: Align(
        alignment: Alignment.centerLeft, // Căn sát lề trái
        child: ServiceItemWidget(
          icon: laundryServices[0]["icon"],
          title: laundryServices[0]["title"],
          color: laundryServices[0]["color"],
          onTap: () {
            AppRouter.navigateToLaundryService();
          },
          fem: fem,
        ),
      ),
    );
  }

}
