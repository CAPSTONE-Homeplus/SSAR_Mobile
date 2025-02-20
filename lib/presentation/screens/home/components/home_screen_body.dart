import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/app_router.dart';
import 'package:home_clean/core/app_text_styles.dart';
import 'package:home_clean/core/validation.dart';
import 'package:home_clean/domain/entities/service/service.dart';

import '../../../../core/constant.dart';
import '../../../../core/size_config.dart';
import '../../../../domain/entities/wallet/wallet.dart';
import '../../../blocs/wallet/wallet_bloc.dart';
import '../../../blocs/wallet/wallet_event.dart';
import '../../../blocs/wallet/wallet_state.dart';
import '../../../widgets/address_bottom_sheet.dart';

class HomeScreenBody extends StatefulWidget {
  List<Service> servicesToFetch;
  List<Wallet> walletUser = [];
  HomeScreenBody({super.key, required this.servicesToFetch, required this.walletUser});

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
    return _buildHomeScreen(widget.servicesToFetch, context, widget.walletUser);
  }
}

Widget _buildHomeScreen(List<Service> services, BuildContext context, List<Wallet> walletUser) {
  String selectedBuilding = '';
  String selectedRoom = '';
  String defaultAddress = 'Ho Chi Minh City';
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
            WalletCardWidget(
              walletUserList: walletUser,
              onAddPoints: () {
                AppRouter.navigateToPayment(walletUser);
              },
              fem: fem,  // Your responsive scaling factor
              ffem: ffem, // Your font scaling factor
            ),
            Padding(
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
                            color: Color(0xFF1CAF7D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12 * hem),
                  Container(
                    height: services.length <= 4 ? 100 * hem : 200 * hem,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 5 : 4 ,
                        crossAxisSpacing: 8 * fem,
                        mainAxisSpacing: 8 * hem,
                      ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return _buildServiceItem(
                          icon: Constant
                                  .iconMapping[service.code?.toLowerCase()] ??
                              Icons.help,
                          title: service.name ?? '',
                          color: Constant.iconColorMapping[
                                  service.code?.toLowerCase()] ??
                              Color(0xFF000000),
                          onTap: () {
                            AppRouter.navigateToServiceDetail(service);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16 * fem),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đơn hàng gần đây',
                    style: GoogleFonts.poppins(
                      fontSize: 18 * ffem,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12 * fem),
                  _buildBookingCard(),
                  SizedBox(height: 12 * fem),
                  _buildBookingCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


class WalletCardWidget extends StatelessWidget {
  final List<Wallet> walletUserList;
  final VoidCallback onAddPoints;
  final double fem;
  final double ffem;

  const WalletCardWidget({
    Key? key,
    required this.walletUserList,
    required this.onAddPoints,
    this.fem = 1.0,
    this.ffem = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16 * fem),
      padding: EdgeInsets.all(20 * fem),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1CAF7D),
            Color(0xFF158F66),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16 * fem),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1CAF7D).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWalletHeader(),
          SizedBox(height: 16 * fem),
          _buildWalletGrid(),
          SizedBox(height: 14 * fem),
          _buildTransactionButton(),
        ],
      ),
    );
  }

  Widget _buildWalletHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8 * fem),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 18 * fem,
              ),
            ),
            SizedBox(width: 10 * fem),
            Text(
              'Ví của tôi',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16 * ffem,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: onAddPoints,
          borderRadius: BorderRadius.circular(8 * fem),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8 * fem, horizontal: 12 * fem),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(8 * fem),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Nạp điểm',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12 * ffem,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6 * fem),
                Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 16 * fem,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12 * fem,
        mainAxisSpacing: 12 * fem,
        childAspectRatio: 1.5,
      ),
      itemCount: walletUserList.length,
      itemBuilder: (context, index) => _buildWalletCard(index),
    );
  }

  Widget _buildWalletCard(int index) {
    final wallet = walletUserList[index];
    final isPersonal = wallet.type == 'Personal';

    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12 * fem),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ]
      ),
      padding: EdgeInsets.all(14 * fem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5 * fem),
                decoration: BoxDecoration(
                  color: isPersonal
                      ? Colors.orange.withOpacity(0.3)
                      : Colors.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6 * fem),
                ),
                child: Icon(
                  isPersonal ? Icons.account_circle : Icons.people,
                  color: isPersonal ? Colors.orange[200] : Colors.blue[200],
                  size: 14 * fem,
                ),
              ),
              SizedBox(width: 6 * fem),
              Expanded(
                child: Text(
                  isPersonal ? 'Ví cá nhân' : 'Ví chung',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12 * ffem,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 10 * fem),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 100 * fem),
                child: Text(
                  '${Validation.formatCurrency(wallet.balance ?? 0)}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20 * ffem,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 4 * fem),
              Padding(
                padding: EdgeInsets.only(bottom: 2 * fem),
                child: Icon(
                  Icons.brightness_1,
                  color: isPersonal ? Colors.amber[300] : Colors.greenAccent[200],
                  size: 8 * fem,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionButton() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10 * fem),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12 * fem),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10 * fem),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                color: Colors.white,
                size: 16 * fem,
              ),
              SizedBox(width: 8 * fem),
              Text(
                'Lịch sử giao dịch',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14 * ffem,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildServiceItem({
  required IconData icon,
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  List<String> words = title.split(' ');
  String firstLine = words.length > 2 ? words.sublist(0, 2).join(' ') : title;
  String secondLine = words.length > 2 ? words.sublist(2).join(' ') : '';

  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8 * SizeConfig.fem),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12 * SizeConfig.fem),
          ),
          child: Icon(icon, color: color, size: 24 * SizeConfig.fem),
        ),
        SizedBox(height: 8 * SizeConfig.fem),
        Text(
          firstLine,
          style: GoogleFonts.poppins(
            fontSize: 12 ,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          secondLine,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildPromotionCard() {
  return Container(
    width: 280,
    margin: EdgeInsets.only(right: 16 * SizeConfig.fem),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12 * SizeConfig.fem),
      color: Colors.white,
      image: DecorationImage(
        image: NetworkImage(
            'https://i.pinimg.com/736x/11/4c/60/114c609160dbcb99469d74fad218cf82.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _buildBookingCard() {
  return Container(
    padding: EdgeInsets.all(16 * SizeConfig.fem),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12 * SizeConfig.fem),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10 * SizeConfig.fem),
              decoration: BoxDecoration(
                color: Color(0xFF1CAF7D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8 * SizeConfig.fem),
              ),
              child: Icon(Icons.cleaning_services, color: Color(0xFF1CAF7D)),
            ),
            SizedBox(width: 12 * SizeConfig.fem),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Home Cleaning',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Today, 15:00',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12 * SizeConfig.hem, vertical: 6 * SizeConfig.fem),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'In Progress',
                style: GoogleFonts.notoSans(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12 * SizeConfig.fem),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '300,000 đ',
              style: AppTextStyles.heading,
            ),
            TextButton(
              onPressed: () {},
              child: Text('View Details'),
            ),
          ],
        ),
      ],
    ),
  );
}
