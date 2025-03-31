import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class CurrencyDisplay extends StatelessWidget {
  final dynamic price;
  final double fontSize;
  final double iconSize;
  final String unit; // Đơn vị (ví dụ: "/ cái", "/ kg")

  const CurrencyDisplay({
    Key? key,
    required this.price,
    this.fontSize = 14, // Mặc định 14
    this.iconSize = 24, // Mặc định 24
    this.unit = "", // Mặc định không có đơn vị
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    String formattedPrice = formatter.format(double.tryParse(price.toString()) ?? 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$formattedPrice$unit", // Thêm đơn vị sau giá
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.stars,
          color: Colors.amber,
          size: iconSize,
        ),
      ],
    );
  }
}
