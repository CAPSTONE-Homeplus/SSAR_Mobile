import 'package:flutter/material.dart';

import '../../domain/entities/time_slot/time_slot.dart';

class TimeSelector extends StatelessWidget {
  /// The currently selected time slot
  final TimeSlot selectedSlot;

  /// List of available time slots to choose from
  final List<TimeSlot> availableSlots;

  /// Callback function when a new slot is selected
  final Function(TimeSlot) onSlotChanged;

  // Define the primary color
  static const Color _primaryColor = Color(0xFF1CAF7D);

  const TimeSelector({
    Key? key,
    required this.selectedSlot,
    required this.availableSlots,
    required this.onSlotChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showTimeSelectionSheet(context);
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: _primaryColor.withOpacity(0.5), width: 1.5),
          borderRadius: BorderRadius.circular(12.0),
          color: _primaryColor.withOpacity(0.1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedSlot.startTime!.isEmpty
                    ? 'Chưa chọn thời gian'
                    : '${selectedSlot.startTime} - ${selectedSlot.endTime}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: _primaryColor.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.access_time, color: _primaryColor),
          ],
        ),
      ),
    );
  }

  void _showTimeSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      'Chọn thời gian',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: _primaryColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              ListView.builder(
                shrinkWrap: true,
                itemCount: availableSlots.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      title: Text(
                        'Không chọn',
                        style: TextStyle(
                          color: selectedSlot.startTime!.isEmpty ? _primaryColor : Colors.black87,
                          fontWeight: selectedSlot.startTime!.isEmpty ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      leading: Icon(
                        Icons.clear,
                        color: selectedSlot.startTime!.isEmpty ? _primaryColor : Colors.grey,
                      ),
                      onTap: () {
                        onSlotChanged(TimeSlot(
                          id: '',
                          startTime: '',
                          endTime: '',
                        ));
                        Navigator.pop(context);
                      },
                      tileColor: selectedSlot.startTime!.isEmpty ? _primaryColor.withOpacity(0.1) : null,
                    );
                  }

                  final slot = availableSlots[index - 1];
                  final isSelected = slot.startTime == selectedSlot.startTime &&
                      slot.endTime == selectedSlot.endTime;

                  return ListTile(
                    title: Text(
                      '${slot.startTime} - ${slot.endTime}',
                      style: TextStyle(
                        color: isSelected ? _primaryColor : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    leading: Icon(
                      Icons.schedule,
                      color: isSelected ? _primaryColor : Colors.grey,
                    ),
                    onTap: () {
                      onSlotChanged(slot);
                      Navigator.pop(context);
                    },
                    tileColor: isSelected ? _primaryColor.withOpacity(0.1) : null,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}