import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/colors.dart';
import 'package:home_clean/domain/entities/time_slot/time_slot.dart';
import 'package:home_clean/presentation/blocs/time_slot/time_slot_bloc.dart';
import 'package:home_clean/presentation/blocs/time_slot/time_slot_event.dart';
import 'package:home_clean/presentation/blocs/time_slot/time_slot_state.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

class WorkTimeSelectionScreen extends StatefulWidget {
  const WorkTimeSelectionScreen({Key? key}) : super(key: key);

  @override
  _WorkTimeSelectionScreenState createState() =>
      _WorkTimeSelectionScreenState();
}

class _WorkTimeSelectionScreenState extends State<WorkTimeSelectionScreen> {
  String _selectedShift = '';
  bool _repeatWeekly = false;
  final TextEditingController _notesController = TextEditingController();
  bool isLoading = true;
  late TimeSlotBloc _timeSlotBloc;
  List<TimeSlot> _timeSlots = [];

  @override
  void initState() {
    super.initState();
    _loadTimeSlots();
  }

  void _loadTimeSlots() async {
    try {
      setState(() {
        isLoading = true;
      });
      _timeSlotBloc = context.read<TimeSlotBloc>();
      _timeSlotBloc.add(GetTimeSlotEvents());
      await _processTimeSlot();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _processTimeSlot() async {
    await for (final state in _timeSlotBloc.stream) {
      if (state is TimeSlotLoaded && mounted) {
        setState(() {
          _timeSlots = state.timeSlots;
        });
        break;
      }
    }
  }

  void _saveWorkTime() {
    if (_selectedShift.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã lưu ca làm việc: $_selectedShift',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppColors.primaryColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vui lòng chọn ca làm việc',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
          title: 'Chọn thời gian làm việc',
          onBackPressed: () {
            Navigator.of(context).pop();
          }),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShiftSelection(),
                  const SizedBox(height: 16),
                  _buildRepeatWeeklyOption(),
                  const SizedBox(height: 16),
                  _buildNotesField(),
                ],
              ),
            ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildShiftSelection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Chọn ca làm việc',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          ..._timeSlots.map((timeSlot) => _buildTimeSlotOption(timeSlot)),
        ],
      ),
    );
  }

  Widget _buildTimeSlotOption(TimeSlot timeSlot) {
    final isSelected = _selectedShift == (timeSlot.id ?? "");
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.access_time,
          color: isSelected ? AppColors.primaryColor : Colors.grey,
          size: 40,
        ),
        title: Text(
          "${timeSlot.startTime ?? ''} - ${timeSlot.endTime ?? ''}",
          style: GoogleFonts.poppins(
            color: isSelected
                ? AppColors.primaryColor.withOpacity(0.7)
                : Colors.grey,
          ),
        ),
        trailing: Radio<String>(
          value: timeSlot.id ?? "",
          groupValue: _selectedShift,
          activeColor: AppColors.primaryColor,
          onChanged: (value) {
            setState(() {
              _selectedShift = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildRepeatWeeklyOption() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(
          'Lặp lại hàng tuần',
          style: GoogleFonts.poppins(),
        ),
        value: _repeatWeekly,
        onChanged: (bool value) {
          setState(() {
            _repeatWeekly = value;
          });
        },
        activeColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _notesController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          labelText: 'Ghi chú',
          labelStyle: GoogleFonts.poppins(color: AppColors.primaryColor),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.notes, color: AppColors.primaryColor),
        ),
        maxLines: 3,
        style: GoogleFonts.poppins(),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _saveWorkTime,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          'Xác nhận',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
