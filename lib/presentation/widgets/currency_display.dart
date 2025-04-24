import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class CurrencyDisplay extends StatelessWidget {
  final dynamic price;
  final double fontSize;
  final double iconSize;
  final String unit; // Đơn vị (ví dụ: "/ cái", "/ kg")
  final TextStyle? style; // Thêm style tùy chọn
  final Color? iconColor; // Thêm màu icon tùy chọn
  final bool isUnitBefore; // Thêm biến để quyết định vị trí của unit

  const CurrencyDisplay({
    Key? key,
    required this.price,
    this.fontSize = 14, // Mặc định 14
    this.iconSize = 24, // Mặc định 24
    this.unit = "", // Mặc định không có đơn vị
    this.style, // Style tùy chọn
    this.iconColor = Colors.amber, // Màu icon mặc định
    this.isUnitBefore = false, // Mặc định unit ở sau
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    String formattedPrice = formatter.format(double.tryParse(price.toString()) ?? 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          isUnitBefore
              ? "$unit$formattedPrice" // Unit đứng trước giá
              : "$formattedPrice$unit", // Unit đứng sau giá
          style: style ?? TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.stars,
          color: iconColor,
          size: iconSize,
        ),
      ],
    );
  }
}