import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:home_clean/presentation/screens/message/message_screen.dart';

import '../screens/home/home_screen.dart';
import '../screens/manage_wallet/manage_wallet_screen/manage_wallet_screen.dart';
import '../screens/setting/settings_screen.dart';

class BottomNavigation extends StatefulWidget {
  final Widget child;

  const BottomNavigation({Key? key, required this.child}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ManageWalletScreen(),
    MessageScreen(),
    SettingsScreen()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey[100]!,
        color: Colors.white,
        buttonBackgroundColor: Colors.greenAccent,
        height: 60,
        index: _currentIndex,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home, size: 30, color: Colors.black),
          Icon(Icons.local_activity, size: 30, color: Colors.black),
          Icon(Icons.message_outlined, size: 30, color: Colors.black),
          Icon(Icons.person_outline, size: 30, color: Colors.black),
        ],
        onTap: _onTabTapped,
      ),
    );
  }
}
