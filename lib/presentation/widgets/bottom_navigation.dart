import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../core/constant/size_config.dart';
import '../screens/home/home_screen.dart';
import '../screens/order_list/order_list_screen.dart';
import '../screens/setting/settings_screen.dart';

class BottomNavigation extends StatefulWidget {
  final int initialIndex;
  final Widget child;
  final String? selectedCategory;

  const BottomNavigation({
    Key? key,
    required this.child,
    this.initialIndex = 0,
    this.selectedCategory = "clean",
  }) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _currentIndex;
  late List<Widget?> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    // Khởi tạo danh sách pages với null
    _pages = List.filled(3, null);
    // Load trang ban đầu
    _loadPage(_currentIndex);
  }

  void _loadPage(int index) {
    if (_pages[index] == null) {
      // Lazy load trang khi chưa được khởi tạo
      setState(() {
        switch (index) {
          case 0:
            _pages[index] = HomeScreen();
            break;
          case 1:
            _pages[index] = OrderListScreen(
              selectedCategory: widget.selectedCategory ?? '',
            );
            break;
          case 2:
            _pages[index] = SettingsScreen();
            break;
        }
      });
    }
  }

  void _onTabTapped(int index) {
    // Load trang trước khi chuyển
    _loadPage(index);

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fem = SizeConfig.fem;
    final hem = SizeConfig.hem;
    final ffem = SizeConfig.ffem;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages.map((page) => page ?? const SizedBox()).toList(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey[100]!,
        color: Colors.white,
        buttonBackgroundColor: Colors.greenAccent,
        height: 60 * hem,
        index: _currentIndex,
        animationDuration: const Duration(milliseconds: 300),
        items: [
          Icon(Icons.home, size: 25 * fem, color: Colors.black),
          Icon(Icons.list_alt, size: 25 * fem, color: Colors.black),
          Icon(Icons.person_outline, size: 25 * fem, color: Colors.black),
        ],
        onTap: _onTabTapped,
      ),
    );
  }
}