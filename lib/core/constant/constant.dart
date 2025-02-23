import 'package:flutter/material.dart';

class Constant {
  static Map<String, IconData> iconMapping = {
    'tongvesinh': Icons.auto_delete,
    'vesinhphong': Icons.bedroom_child,
    'trongtre': Icons.child_friendly,
    'chuyennha': Icons.house,
    'vssd': Icons.home_repair_service,
  };

  static Map<String, Color> iconColorMapping = {
    'tongvesinh': Color(0xFF1CAF7D),
    'vesinhphong': Color.fromARGB(255, 255, 99, 71),
    'trongtre': Color(0xFF1E90FF),
    'chuyennha': Color(0xFF8A2BE2),
    'vssd': Color(0xFFFFA500),
  };

  static const int defaultPage = 1;
  static const int defaultSize = 100;
}
