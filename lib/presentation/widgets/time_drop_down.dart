import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/time_slot/time_slot.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/time_slot/time_slot.dart';

class TimeDropdown extends StatelessWidget {
  final TimeSlot? value;
  final List<TimeSlot> items;
  final ValueChanged<TimeSlot?> onChanged;

  const TimeDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: DropdownButton<TimeSlot?>(
        value: _validateValue(value, items),
        icon: const Icon(Icons.access_time, color: Colors.black),
        isExpanded: true,
        underline: const SizedBox(),
        onChanged: onChanged,
        hint: Text(
          'Chọn giờ',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
        ),
        items: _buildDropdownItems(),
      ),
    );
  }

  List<DropdownMenuItem<TimeSlot?>> _buildDropdownItems() {
    return [
      const DropdownMenuItem<TimeSlot?>(
        value: null,
        child: Text(
          'Chọn giờ',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      ...items.map((TimeSlot timeSlot) {
        return DropdownMenuItem<TimeSlot>(
          value: timeSlot,
          child: Text(
            '${_removeSeconds(timeSlot.startTime)} - ${_removeSeconds(timeSlot.endTime)}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        );
      }).toList()
    ];
  }

  TimeSlot? _validateValue(TimeSlot? currentValue, List<TimeSlot> availableItems) {
    return availableItems.contains(currentValue) ? currentValue : null;
  }

  String _removeSeconds(String? time) {
    if (time == null) return '';
    return time.contains(':00') ? time.substring(0, time.lastIndexOf(':00')) : time;
  }
}
