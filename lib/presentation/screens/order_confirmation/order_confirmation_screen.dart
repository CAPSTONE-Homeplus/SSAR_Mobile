import 'package:flutter/material.dart';
import 'package:home_clean/core/validation.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/entities/order/create_order.dart';
import '../../widgets/step_indicator_widget.dart';
import '../map/map_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final CreateOrder orderDetails;

  const OrderConfirmationScreen({
    Key? key,
    required this.orderDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Xác nhận', onBackPressed: () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress indicator
            StepIndicatorWidget(currentStep: 3),
            const SizedBox(height: 8),
            _buildSection(
              title: 'Địa chỉ',
              icon: Icons.location_on_outlined,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderDetails.address,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Service details card
            _buildSection(
              title: 'Chi tiết dịch vụ',
              icon: Icons.cleaning_services_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    title: 'Dịch vụ',
                    value: orderDetails.service.name ?? 'Dọn dẹp căn hộ',
                    icon: Icons.home_work_outlined,
                  ),
                  if (orderDetails.emergencyRequest)
                    _buildEmergencyBadge(),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    title: 'Thời gian',
                    value: '${orderDetails.timeSlot.startTime} - ${orderDetails.timeSlot.endTime}',
                    icon: Icons.access_time,
                  ),
                ],
              ),
            ),

            // Selected options
            if (orderDetails.option.isNotEmpty)
              _buildSection(
                title: 'Tùy chọn đã chọn',
                icon: Icons.checklist_outlined,
                child: Column(
                  children: orderDetails.option!.map((option) =>
                      _buildOptionItem(
                        title: option.name ?? '',
                        price: option.price ?? 0,
                      ),
                  ).toList(),
                ),
              ),

            // Extra services
            if (orderDetails.extraService.isNotEmpty)
              _buildSection(
                title: 'Dịch vụ thêm',
                icon: Icons.add_circle_outline,
                child: Column(
                  children: orderDetails.extraService.map((service) =>
                      _buildOptionItem(
                        title: service.name ?? '',
                        price: service.price ?? 0,
                      ),
                  ).toList(),
                ),
              ),

            // Notes section
            if (orderDetails.notes.isNotEmpty)
              _buildSection(
                title: 'Ghi chú',
                icon: Icons.note_outlined,
                child: Text(
                  orderDetails.notes,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),

            const SizedBox(height: 100), // Space for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
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
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted ? color : Colors.transparent,
            border: Border.all(
              color: color,
              width: 2,
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
            fontSize: 12,
            color: color,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector({required bool isCompleted}) {
    return Container(
      width: 40,
      height: 2,
      color: isCompleted ? const Color(0xFF1CAF7D) : Colors.grey[300],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF1CAF7D), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    required IconData icon,
  }) {
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

  Widget _buildEmergencyBadge() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flash_on, size: 16, color: Colors.red[700]),
          const SizedBox(width: 4),
          Text(
            'Dịch vụ siêu tốc',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.red[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required String title,
    required int price,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
          Text(
            Validation.formatCurrency(price),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1CAF7D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement order confirmation
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1CAF7D),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'Xác nhận đặt dịch vụ',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}