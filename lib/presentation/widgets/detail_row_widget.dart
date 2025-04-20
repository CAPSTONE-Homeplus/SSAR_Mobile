import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailRowWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DetailRowWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailRowMultiInfoWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final List<Map<String, String>> values; // label + value
  final double verticalSpacing;

  const DetailRowMultiInfoWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.values,
    this.iconColor,
    this.verticalSpacing = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor ?? Colors.grey[700]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                ...values.map(
                      (item) => Padding(
                    padding: EdgeInsets.only(bottom: verticalSpacing),
                    child: Row(
                      children: [
                        Text(
                          '${item['label']}: ',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item['value'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
