import 'package:collection/collection.dart';
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
    final now = DateTime.now();
    final filteredSlots = availableSlots.where((slot) {
      final slotTime = _parseTimeToDateTime(slot.startTime ?? '');
      return slotTime.isAfter(now.add(Duration(hours: 0)));
    }).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // Header row
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
                  // Scrollable content
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        ListTile(
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
                        ),

                        ...filteredSlots
                            .sorted((a, b) => _parseTimeToDateTime(a.startTime ?? '')
                            .compareTo(_parseTimeToDateTime(b.startTime ?? '')))
                            .map((slot) {
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
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

// Hàm hỗ trợ chuyển đổi startTime thành DateTime
  DateTime _parseTimeToDateTime(String timeString) {
    try {
      // Giả sử format của timeString là 'HH:mm'
      final now = DateTime.now();
      final timeParts = timeString.split(':');

      return DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(timeParts[0]),
          int.parse(timeParts[1])
      );
    } catch (e) {
      // Trả về thời gian hiện tại nếu không parse được
      return DateTime.now();
    }
  }
}