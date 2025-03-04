import 'package:flutter/material.dart';
import 'package:home_clean/core/constant/colors.dart';

class PersonalWalletError extends StatelessWidget {
  const PersonalWalletError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Center(
              child: Text(
                'Không thể tải dữ liệu.',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}