import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenLoading extends StatelessWidget {
  const HomeScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phòng bạn đang ở',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            Row(
              children: [
                Text(
                  '',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
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
              child: _buildShimmerEffect(
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
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 30,
                            width: 80,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        color: Colors.grey,
                      ),
                    ],
                  ),
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
                  _buildShimmerEffect(
                    child: Container(
                      height: 20,
                      width: 100,
                      color: Colors.grey,
                    ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
    );
  }

  Widget _buildServiceItemLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildShimmerEffect(
          child: Container(
            height: 40,
            width: 40,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 8),
        _buildShimmerEffect(
          child: Container(
            height: 10,
            width: 50,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionCardLoading() {
    return _buildShimmerEffect(
      child: Container(
        width: 280,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildBookingCardLoading() {
    return _buildShimmerEffect(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey,
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
      ),
    );
  }
}
