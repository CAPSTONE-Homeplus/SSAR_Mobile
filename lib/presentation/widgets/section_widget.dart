import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? contentPadding;
  final Color iconColor;
  final double iconSize;
  final TextStyle? titleStyle;

  const SectionWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.headerPadding = const EdgeInsets.all(16),
    this.contentPadding = const EdgeInsets.fromLTRB(16, 0, 16, 16),
    this.iconColor = const Color(0xFF1CAF7D),
    this.iconSize = 20,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultTitleStyle = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: headerPadding!,
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: iconSize),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: titleStyle ?? defaultTitleStyle,
                ),
              ],
            ),
          ),
          Padding(
            padding: contentPadding!,
            child: child,
          ),
        ],
      ),
    );
  }
}