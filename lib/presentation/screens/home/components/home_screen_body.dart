import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/domain/entities/service/service.dart';
import 'package:home_clean/presentation/screens/home/components/room_header.dart';
import 'package:home_clean/presentation/screens/home/components/service/service_grid.dart';
import 'package:home_clean/presentation/screens/home/components/wallet/wallet_container.dart';
import 'package:home_clean/presentation/screens/home/components/wallet_grid/wallet_grid.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../../core/constant/size_config.dart';
import '../../../../domain/entities/building/building.dart';
import '../../../../domain/entities/house/house.dart';
import '../../../../domain/entities/laundry_service_type/laundry_service_type.dart';
import '../../../../domain/entities/user/user.dart';
import '../../../../domain/entities/wallet/wallet.dart';
import '../../address_option/address_option_screen.dart';
import 'laundry_service/laundry_grid_widget.dart';

class HomeScreenBody extends StatefulWidget {
  List<Service> servicesToFetch;
  List<Wallet> walletUser = [];
  User user;
  House house;
  Building building;

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
