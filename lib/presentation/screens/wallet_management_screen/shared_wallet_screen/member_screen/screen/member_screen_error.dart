import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MemberScreenError extends StatelessWidget {
  const MemberScreenError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Không thể tải dữ liệu.',
          style: TextStyle(
            color: const Color(0xFF1FB075),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
