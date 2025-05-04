import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/presentation/screens/home/components/service/service_item.dart';

import '../../../../../core/constant/constants.dart';
import '../../../../../core/constant/size_config.dart';
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
          _buildHeader(),
          SizedBox(height: 12 * hem),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth ~/ (100 * fem);
              crossAxisCount = crossAxisCount > 2 ? crossAxisCount : 2; // Ít nhất 2 cột

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8 * fem,
                  mainAxisSpacing: 8 * hem,
                  childAspectRatio: 1.2,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ServiceItemWidget(
                    icon: Constant.iconMapping[service.code] ?? Icons.help,
                    title: service.name ?? '',
                    color: Constant.iconColorMapping[service.code] ?? const Color(0xFF000000),
                    onTap: () {
                      AppRouter.navigateToServiceDetail(service.id ?? '');
                    },
                    fem: fem,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Dịch Vụ Dọn Dẹp',
          style: GoogleFonts.poppins(
            fontSize: 18 * ffem,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
