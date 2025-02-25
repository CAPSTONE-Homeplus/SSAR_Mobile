import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/core/format/validation.dart';
import 'package:home_clean/domain/entities/service/service.dart';
import 'package:home_clean/presentation/screens/home/components/service/service_grid.dart';
import 'package:home_clean/presentation/screens/home/components/wallet/transaction_button.dart';
import 'package:home_clean/presentation/screens/home/components/wallet/wallet_container.dart';
import 'package:home_clean/presentation/screens/home/components/wallet/wallet_grid.dart';
import 'package:home_clean/presentation/screens/home/components/wallet/wallet_header.dart';

import '../../../../core/constant/constant.dart';
import '../../../../core/constant/size_config.dart';
import '../../../../domain/entities/user/user.dart';
import '../../../../domain/entities/wallet/wallet.dart';
import '../../../widgets/address_bottom_sheet.dart';

class HomeScreenBody extends StatefulWidget {
  List<Service> servicesToFetch;
  List<Wallet> walletUser = [];
  User user;
  HomeScreenBody({super.key, required this.servicesToFetch,
    required this.walletUser, required this.user});

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
    return _buildHomeScreen(widget.servicesToFetch, context, widget.walletUser, widget.user);
  }
}

Widget _buildHomeScreen(List<Service> services, BuildContext context, List<Wallet> walletUser, User user) {
  String selectedBuilding = '';
  String selectedRoom = '';
  String defaultAddress = user.fullName ?? '';
  final fem = SizeConfig.fem;
  final hem = SizeConfig.hem;
  final ffem = SizeConfig.ffem;

  return Container(
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vị trí hiện tại',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 12 * ffem,
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddressBottomSheet(
                    currentAddress: defaultAddress,
                    currentBuilding: selectedBuilding,
                    currentRoom: selectedRoom,
                    onAddressSelected: (address, building, room) {
                      (() {
                        defaultAddress = address;
                        selectedBuilding = building;
                        selectedRoom = room;
                      });
                    },
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    defaultAddress,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
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
          ],
        ),
      ),
    ),
  );
}


