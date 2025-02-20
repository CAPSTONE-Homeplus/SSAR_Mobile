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
            Container(
              margin: EdgeInsets.all(16 * fem),
              padding: EdgeInsets.all(16 * fem),
              decoration: BoxDecoration(
                color: Color(0xFF1CAF7D),
                borderRadius: BorderRadius.circular(12 * fem),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1CAF7D).withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.stars_rounded,
                        color: Colors.white70,
                        size: 16 * fem,
                      ),
                      SizedBox(width: 4 * fem),
                      Text(
                        'Điểm tích lũy',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12 * fem),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12 * fem,
                      mainAxisSpacing: 12 * fem,
                      childAspectRatio: 1.6,
                    ),
                    itemCount: walletUser.length,
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12 * fem),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.all(12 * fem),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                index == 0 ? Icons.wallet_membership : Icons.card_membership,
                                color: Colors.white70,
                                size: 14 * fem,
                              ),
                              SizedBox(width: 4 * fem),
                              Expanded(
                                child: Text(
                                  '${walletUser[index].name}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 10 * ffem,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8 * fem),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${Validation.formatCurrency(walletUser[index].balance ?? 0)}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                              ),
                              SizedBox(width: 4 * fem),
                              Padding(
                                padding: EdgeInsets.only(bottom: 2 * fem),
                                child: Icon(
                                  Icons.circle_notifications,
                                  color: Colors.yellow,
                                  size: 16 * fem,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
