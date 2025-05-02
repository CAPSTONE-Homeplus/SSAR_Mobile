import 'package:flutter/material.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/domain/entities/service/service.dart';
import 'package:home_clean/presentation/screens/home/components/service/service_grid.dart';
import 'package:home_clean/presentation/screens/home/components/wallet/wallet_container.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../../core/constant/size_config.dart';
import '../../../../domain/entities/building/building.dart';
import '../../../../domain/entities/house/house.dart';
import '../../../../domain/entities/user/user.dart';
import '../../../../domain/entities/wallet/wallet.dart';
import 'laundry_service/laundry_grid_widget.dart';

class HomeScreenBody extends StatefulWidget {
  final List<Service> servicesToFetch;
  final List<Wallet> walletUser;
  final User user;
  final House house;
  final Building building;

  HomeScreenBody(
      {super.key,
      required this.servicesToFetch,
      required this.walletUser,
      required this.user,
      required this.house,
      required this.building});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}



class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHomeScreen(widget.servicesToFetch, context, widget.walletUser,
        widget.user, widget.house, widget.building);
  }
}

Widget _buildHomeScreen(List<Service> services, BuildContext context,
    List<Wallet> walletUser, User user, House house, Building building) {
  String defaultRoom = house.numberOfRoom ?? '';
  String defaultBuilding = building.name ?? '';
  String address = 'Phòng $defaultRoom, $defaultBuilding';
  final fem = SizeConfig.fem;
  final hem = SizeConfig.hem;
  final ffem = SizeConfig.ffem;

  return Scaffold(
    backgroundColor: Colors.white,
    appBar: CustomAppBar(
      isHomePage: true,
      roomAddress: address,
      isVerified: user.status == 'Active' ? true : false,
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          WalletContainer(
            walletUserList: walletUser,
            onAddPoints: () {
              AppRouter.navigateToPayment();
            },
            fem: fem,
            ffem: ffem,
          ),
          const SizedBox(height: 10),
          _buildConvenienceMarketingWidget(),
          ServiceGridWidget(
            services: services,
            fem: fem,
            ffem: ffem,
            hem: hem,
          ),
          LaundryGridWidget(
            fem: fem,
            ffem: ffem,
            hem: hem,
          ),
        ],
      ),
    ),
  );
}

Widget _buildConvenienceMarketingWidget() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.green.shade100
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.touch_app_rounded,
            color: Colors.green.shade700,
            size: 40,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiện lợi tức thì',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                Text(
                  'Chạm - Đặt - Nhận ngay, mọi dịch vụ trong một ứng dụng',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
