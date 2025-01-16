import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/presentation/blocs/service/service_bloc.dart';
import 'package:home_clean/presentation/blocs/service/service_event.dart';
import 'package:home_clean/presentation/blocs/service/service_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<ServiceBloc>()
        .add(GetServicesEvent(search: '', orderBy: '', page: 1, size: 8));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoadingState) {
          return _buildLoadingScreen();
        } else if (state is ServiceSuccessState) {
          return _buildHomeScreen();
        } else {
          return _buildHomeScreen();
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Location',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            Row(
              children: [
                Text(
                  'Ho Chi Minh City',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey)
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
            // Placeholder for Balance Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 120,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 30,
                          width: 80,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 100,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),

            // Placeholder for Services Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: List.generate(8, (index) {
                  return _buildServiceItemLoading();
                }),
              ),
            ),

            // Placeholder for Promotions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 100,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildPromotionCardLoading(),
                        _buildPromotionCardLoading(),
                        _buildPromotionCardLoading(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Placeholder for Recent Bookings
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 150,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 12),
                  _buildBookingCardLoading(),
                  SizedBox(height: 12),
                  _buildBookingCardLoading(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItemLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          color: Colors.grey.shade400,
        ),
        SizedBox(height: 8),
        Container(
          height: 10,
          width: 50,
          color: Colors.grey.shade400,
        ),
      ],
    );
  }

  Widget _buildPromotionCardLoading() {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildBookingCardLoading() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                color: Colors.grey.shade500,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      width: 120,
                      color: Colors.grey.shade500,
                    ),
                    SizedBox(height: 6),
                    Container(
                      height: 10,
                      width: 80,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
              Container(
                height: 20,
                width: 60,
                color: Colors.grey.shade500,
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 15,
                width: 60,
                color: Colors.grey.shade500,
              ),
              Container(
                height: 15,
                width: 80,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Location',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            Row(
              children: [
                Text(
                  'Ho Chi Minh City',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey)
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
            // Balance Card
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1CAF7D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Balance',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '500,000 đ',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF1CAF7D),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Text('Top up'),
                  ),
                ],
              ),
            ),

            // Services Grid
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildServiceItem(
                  icon: Icons.cleaning_services,
                  title: 'Cleaning',
                  color: Color(0xFF1CAF7D),
                ),
                _buildServiceItem(
                  icon: Icons.local_laundry_service,
                  title: 'Laundry',
                  color: Colors.blue,
                ),
                _buildServiceItem(
                  icon: Icons.shopping_basket,
                  title: 'Shopping',
                  color: Colors.orange,
                ),
                _buildServiceItem(
                  icon: Icons.restaurant,
                  title: 'Food',
                  color: Colors.red,
                ),
                _buildServiceItem(
                  icon: Icons.cleaning_services,
                  title: 'Deep Clean',
                  color: Colors.purple,
                ),
                _buildServiceItem(
                  icon: Icons.pest_control,
                  title: 'Sanitize',
                  color: Colors.teal,
                ),
                _buildServiceItem(
                  icon: Icons.more_horiz,
                  title: 'More',
                  color: Colors.grey,
                ),
              ],
            ),

            // Promotions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Promotions',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildPromotionCard(),
                        _buildPromotionCard(),
                        _buildPromotionCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Recent Bookings
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Bookings',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildBookingCard(),
                  SizedBox(height: 12),
                  _buildBookingCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPromotionCard() {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF1CAF7D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.cleaning_services, color: Color(0xFF1CAF7D)),
              ),
              SizedBox(width: 12),
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
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'In Progress',
                  style: GoogleFonts.poppins(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '300,000 đ',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF1CAF7D),
                ),
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
}
