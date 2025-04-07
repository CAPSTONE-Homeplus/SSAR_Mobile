import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../core/constant/size_config.dart';
import '../screens/home/home_screen.dart';
import '../screens/notification/notification.dart';
import '../screens/order_list/order_list_screen.dart';
import '../screens/setting/settings_screen.dart';

class BottomNavigation extends StatefulWidget {
  final int initialIndex;
  final Widget child;

  const BottomNavigation({
    Key? key,
    required this.child,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _currentIndex;

  final List<Widget> _pages = [
    HomeScreen(),
    OrderListScreen(),
    NotificationScreen(),
    SettingsScreen()
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
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
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey[100]!,
        color: Colors.white,
        buttonBackgroundColor: Colors.greenAccent,
        height: 60 * hem,
        index: _currentIndex,
        animationDuration: const Duration(milliseconds: 300),
        items: [
          Icon(Icons.home, size: 30 * fem, color: Colors.black),
           Icon(Icons.list_alt, size: 30 * fem, color: Colors.black),
           Icon(Icons.notifications, size: 30 * fem, color: Colors.black),
           Icon(Icons.person_outline, size: 30 * fem, color: Colors.black),
        ],
        onTap: _onTabTapped,
      ),
    );
  }
}
