import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/presentation/screens/home/components/service/service_item.dart';

import '../../../../../core/router/app_router.dart';


class LaundryGridWidget extends StatelessWidget {
  final double fem;
  final double ffem;
  final double hem;

  const LaundryGridWidget({
    Key? key,
    required this.fem,
    required this.ffem,
    required this.hem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16 * fem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dịch vụ giặt sấy',
                style: GoogleFonts.poppins(
                  fontSize: 18 * ffem,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12 * hem),
          SizedBox(
            height: 150,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 4,
                crossAxisSpacing: 8 * fem,
                mainAxisSpacing: 8 * hem,
              ),
              itemCount: 1,
              itemBuilder: (context, index) {
                return ServiceItemWidget(
                  icon: Icons.local_laundry_service,
                  title: "Giặt Sấy",
                  color: Colors.blueAccent,
                  onTap: () {
                    AppRouter.navigateToLaundryService();
                  },
                  fem: fem,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
