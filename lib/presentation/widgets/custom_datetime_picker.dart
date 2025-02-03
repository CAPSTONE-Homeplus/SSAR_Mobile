import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustomDateTimePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateChanged;

  const CustomDateTimePicker(
      {Key? key, required this.initialDate, required this.onDateChanged})
      : super(key: key);

  @override
  _CustomDateTimePickerState createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  late DateTime _selectedDate;
  final List<DateTime> _dateRange = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _generateDateRange();
  }

  void _generateDateRange() {
    DateTime startDate = DateTime.now();
    for (int i = 0; i < 30; i++) {
      _dateRange.add(startDate.add(Duration(days: i)));
    }
  }

  String _getWeekdayName(DateTime date) {
    final Map<int, String> weekdays = {
      1: 'T2',
      2: 'T3',
      3: 'T4',
      4: 'T5',
      5: 'T6',
      6: 'T7',
      7: 'CN',
    };
    return weekdays[date.weekday] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dateRange.length,
        itemBuilder: (context, index) {
          DateTime currentDate =
              _dateRange[index].toUtc().add(Duration(hours: 7));

          bool isSelected = _selectedDate.year == currentDate.year &&
              _selectedDate.month == currentDate.month &&
              _selectedDate.day == currentDate.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = currentDate;
              });
              widget.onDateChanged(currentDate);
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1CAF7D) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 1,
                  color: isSelected
                      ? const Color(0xFF1CAF7D)
                      : Colors.brown.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Đổ bóng
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getWeekdayName(currentDate),
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    currentDate.day.toString(),
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('MMMM', 'vi_VN').format(
                        currentDate), // 'MMMM' sẽ trả về tên tháng đầy đủ
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
