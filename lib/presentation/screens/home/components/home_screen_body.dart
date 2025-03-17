import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/domain/entities/service/service.dart';
import 'package:home_clean/presentation/screens/home/components/service/service_grid.dart';
import 'package:home_clean/presentation/screens/home/components/wallet/wallet_container.dart';
import 'package:home_clean/presentation/screens/home/components/wallet_grid/wallet_grid.dart';

import '../../../../core/constant/size_config.dart';
import '../../../../domain/entities/building/building.dart';
import '../../../../domain/entities/house/house.dart';
import '../../../../domain/entities/user/user.dart';
import '../../../../domain/entities/wallet/wallet.dart';
import '../../address_option/address_option_screen.dart';

class HomeScreenBody extends StatefulWidget {
  List<Service> servicesToFetch;
  List<Wallet> walletUser = [];
  User user;
  House house;
  Building building;

  HomeScreenBody({super.key, required this.servicesToFetch,
    required this.walletUser, required this.user, required this.house, required this.building});

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
    return _buildHomeScreen(widget.servicesToFetch, context, widget.walletUser, widget.user, widget.house, widget.building);
  }
}

Widget _buildHomeScreen(List<Service> services, BuildContext context, List<Wallet> walletUser, User user, House house, Building building) {
  String defaultRoom = house.numberOfRoom ?? '';
  String defaultBuilding = building.name ?? '';
  String address = 'Phòng $defaultRoom, $defaultBuilding';
  final fem = SizeConfig.fem;
  final hem = SizeConfig.hem;
  final ffem = SizeConfig.ffem;

  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phòng bạn đang ở',
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 12 * ffem,
            ),
          ),
          Row(
              children: [
                Text(
                  address,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: Colors.black),
          onPressed: () {},
        ),
      ],
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
          ServiceGridWidget(
            services: services,
            fem: fem,
            ffem: ffem,
            hem: hem,
          ),
          WalletGrid(
            wallets: walletUser,
            fem: fem,
            ffem: ffem,
            hem: hem,
          ),
        ],
      ),
    ),
  );
}


