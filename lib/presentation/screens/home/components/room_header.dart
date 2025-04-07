import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomHeader extends StatelessWidget {
  final String address;
  final VoidCallback? onNotificationPressed;
  final double ffem;

  const RoomHeader({
    Key? key,
    required this.address,
    this.onNotificationPressed,
    this.ffem = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Địa chỉ phòng
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phòng bạn đang ở',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 12 * ffem,
                ),
              ),
              const SizedBox(height: 4),
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

          // Nút thông báo
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 24 * ffem,
            ),
            onPressed: onNotificationPressed ?? () {},
          ),
        ],
      ),
    );
  }
}
