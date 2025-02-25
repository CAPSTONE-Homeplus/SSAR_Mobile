import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final double fem;

  const ServiceItemWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    required this.fem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> words = title.split(' ');
    String firstLine = words.length > 2 ? words.sublist(0, 2).join(' ') : title;
    String secondLine = words.length > 2 ? words.sublist(2).join(' ') : '';

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8 * fem),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12 * fem),
            ),
            child: Icon(icon, color: color, size: 24 * fem),
          ),
          SizedBox(height: 8 * fem),
          Text(
            firstLine,
            style: GoogleFonts.poppins(
              fontSize: 12,
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
}
