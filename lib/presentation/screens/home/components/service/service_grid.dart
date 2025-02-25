import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/presentation/screens/home/components/service/service_item.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../domain/entities/service/service.dart';


class ServiceGridWidget extends StatelessWidget {
  final List<Service> services;
  final double fem;
  final double ffem;
  final double hem;

  const ServiceGridWidget({
    Key? key,
    required this.services,
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
                'Dịch vụ',
                style: GoogleFonts.poppins(
                  fontSize: 18 * ffem,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  AppRouter.navigateToServiceDetails();
                },
                child: Text(
                  'Xem tất cả',
                  style: GoogleFonts.poppins(
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1CAF7D),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12 * hem),
          SizedBox(
            height: services.length <= 4 ? 100 * hem : 200 * hem,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 4,
                crossAxisSpacing: 8 * fem,
                mainAxisSpacing: 8 * hem,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return ServiceItemWidget(
                  icon: Constant.iconMapping[service.code?.toLowerCase()] ??
                      Icons.help,
                  title: service.name ?? '',
                  color: Constant.iconColorMapping[service.code?.toLowerCase()] ??
                      const Color(0xFF000000),
                  onTap: () {
                    AppRouter.navigateToServiceDetail(service);
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
