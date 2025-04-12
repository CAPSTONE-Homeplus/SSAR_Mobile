import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/time_slot/time_slot.dart';

class TimeDropdown extends StatelessWidget {
  final TimeSlot? selectedSlot;
  final List<TimeSlot> availableSlots;
  final ValueChanged<TimeSlot?> onSlotChanged;

  const TimeDropdown({
    Key? key,
    required this.selectedSlot,
    required this.availableSlots,
    required this.onSlotChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dropdownItems = _buildDropdownItems();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TimeSlot?>(
          dropdownColor: Colors.white,
          value: dropdownItems.map((item) => item.value).contains(selectedSlot)
              ? selectedSlot
              : null, // Explicitly set to null if not in items
          isExpanded: true,
          hint: _buildHintWidget(),
          icon: _buildDropdownIcon(),
          onChanged: (TimeSlot? newValue) {
            // Always call the callback, even with null
            onSlotChanged(newValue);
          },
          items: dropdownItems,
        ),
      ),
    );
  }

  Widget _buildHintWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Chọn khung giờ',
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildDropdownIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Icon(
        Icons.schedule_rounded,
        color: Colors.green[700],
        size: 24,
      ),
    );
  }

  List<DropdownMenuItem<TimeSlot?>> _buildDropdownItems() {
    final validSlots = _getValidTimeSlots();

    List<DropdownMenuItem<TimeSlot?>> items = [
      // Thêm mục để xóa lựa chọn
      DropdownMenuItem<TimeSlot?>(
        value: null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Xóa lựa chọn',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.red[400],
            ),
          ),
        ),
      ),
    ];

    if (validSlots.isEmpty) {
      items.add(_buildUnavailableItem());
      return items;
    }

    // Thêm các slot hợp lệ
    items.addAll(
      validSlots.map((timeSlot) {
        return DropdownMenuItem<TimeSlot>(
          value: timeSlot,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${_formatTime(timeSlot.startTime)} - ${_formatTime(timeSlot.endTime)}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );

    return items;
  }

  DropdownMenuItem<TimeSlot?> _buildUnavailableItem() {
    return DropdownMenuItem<TimeSlot?>(
      value: null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Không có khung giờ',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.red[400],
          ),
        ),
      ),
    );
  }

  List<TimeSlot> _getValidTimeSlots() {
    final now = DateTime.now();
    return availableSlots.where((slot) {
      final startTime = _parseTime(slot.startTime);
      return startTime != null && startTime.isAfter(now.add(const Duration(hours: 1)));
    }).toList();
  }

  DateTime? _parseTime(String? timeStr) {
    if (timeStr == null) return null;
    try {
      final parts = timeStr.split(':');
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day,
          int.parse(parts[0]), int.parse(parts[1]));
    } catch (_) {
      return null;
    }
  }

  String _formatTime(String? time) {
    if (time == null) return '';
    return time.contains(':00')
        ? time.substring(0, time.lastIndexOf(':00'))
        : time;
  }
}