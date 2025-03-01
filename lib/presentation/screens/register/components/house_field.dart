import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../domain/entities/house/house.dart';
import '../../../blocs/house/house_bloc.dart';
import '../../../blocs/house/house_state.dart';

class HouseCodeFieldWidget extends StatelessWidget {
  final TextEditingController houseCodeController;
  final HouseBloc houseBloc;
  final Function(House) onHouseSelected;

  const HouseCodeFieldWidget({
    Key? key,
    required this.houseCodeController,
    required this.houseBloc,
    required this.onHouseSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HouseBloc, HouseState>(
      bloc: houseBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Số căn hộ (101, 102, ...)',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            if (state is HouseLoading)
              Stack(
                alignment: Alignment.center,
                children: [
                  _buildHouseTextField(null), // Hiển thị TextField mờ khi loading
                  const CircularProgressIndicator(color: Color(0xFF1CAF7D)),
                ],
              )
            else if (state is HouseLoaded)
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (state.houses.items.isEmpty) return const [];
                  return state.houses.items
                      .where((house) => house.code != null &&
                      house.code!.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                      .map((house) => house.code!)
                      .toList();
                },
                onSelected: (selectedHouse) {
                  houseCodeController.text = selectedHouse;
                  final house = state.houses.items.firstWhere(
                          (house) => house.code == selectedHouse);
                  onHouseSelected(house);
                },
                fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                  return _buildHouseTextField(textEditingController, focusNode);
                },
              )
            else
              _buildHouseTextField(null), // Fallback TextField
          ],
        );
      },
    );
  }

  Widget _buildHouseTextField(TextEditingController? controller, [FocusNode? focusNode]) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: controller != null, // Disable khi loading hoặc lỗi
      decoration: InputDecoration(
        hintText: 'Nhập số phòng',
        hintStyle: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.grey[400],
        ),
        prefixIcon: Icon(
          Icons.meeting_room,
          color: controller != null ? const Color(0xFF1CAF7D) : Colors.grey,
        ),
        filled: true,
        fillColor: controller != null ? Colors.white : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1CAF7D)),
        ),
        // Hiển thị helper text khi không có dữ liệu
        helperText: controller != null && controller.text.isEmpty
            ? 'Không tìm thấy căn hộ trong tòa nhà này'
            : null,
        helperStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
