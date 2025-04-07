import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constant/size_config.dart';

class StepIndicatorWidget extends StatelessWidget {
  final int currentStep;

  const StepIndicatorWidget({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tính toán lại SizeConfig cho màn hình
    SizeConfig.init(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16 * SizeConfig.hem), // Adjust padding
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepIndicator(number: '1', title: 'Chọn dịch vụ', isCompleted: currentStep >= 1),
          _buildStepConnector(isCompleted: currentStep >= 2),
          _buildStepIndicator(number: '2', title: 'Dặt lịch', isActive: currentStep == 2, isCompleted: currentStep > 2),
          _buildStepConnector(isCompleted: currentStep >= 3),
          _buildStepIndicator(number: '3', title: 'Xác nhận', isActive: currentStep == 3, isCompleted: currentStep > 3),
          _buildStepConnector(isCompleted: currentStep >= 4),
          _buildStepIndicator(number: '4', title: 'Hoàn tất', isCompleted: currentStep >= 4),
        ],
      ),
    );
  }

  Widget _buildStepIndicator({
    required String number,
    required String title,
    bool isCompleted = false,
    bool isActive = false,
  }) {
    final color = isCompleted
        ? const Color(0xFF1CAF7D)
        : isActive
        ? const Color(0xFF1CAF7D)
        : Colors.grey;

    return Column(
      children: [
        Container(
          width: 36 * SizeConfig.ffem, // Scale width based on screen size
          height: 36 * SizeConfig.ffem, // Scale height based on screen size
          decoration: BoxDecoration(
            color: isCompleted ? color : Colors.transparent,
            border: Border.all(
              color: color,
              width: 2 * SizeConfig.ffem, // Scale border width
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
              number,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12 * SizeConfig.ffem, // Scale font size based on screen size
            color: color,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector({required bool isCompleted}) {
    return Container(
      width: 40 * SizeConfig.ffem, // Scale width based on screen size
      height: 2 * SizeConfig.ffem,  // Scale height based on screen size
      color: isCompleted ? const Color(0xFF1CAF7D) : Colors.grey[300],
    );
  }
}
