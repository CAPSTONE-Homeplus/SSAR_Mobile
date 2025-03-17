import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressSelectionBottomSheet extends StatefulWidget {
  final String? currentRoom;
  final String? currentBuilding;
  final List<String> availableBuildings;
  final Function(String room, String building) onAddressSelected;

  const AddressSelectionBottomSheet({
    Key? key,
    this.currentRoom,
    this.currentBuilding,
    required this.availableBuildings,
    required this.onAddressSelected,
  }) : super(key: key);

  @override
  _AddressSelectionBottomSheetState createState() => _AddressSelectionBottomSheetState();
}

class _AddressSelectionBottomSheetState extends State<AddressSelectionBottomSheet> {
  late TextEditingController _roomController;
  String? _selectedBuilding;

  @override
  void initState() {
    super.initState();
    _roomController = TextEditingController(text: widget.currentRoom ?? '');
    _selectedBuilding = widget.currentBuilding;
  }

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chọn địa chỉ',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),

          // Room Number Input
          TextField(
            controller: _roomController,
            decoration: InputDecoration(
              labelText: 'Số phòng',
              labelStyle: GoogleFonts.poppins(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
          ),

          SizedBox(height: 16),

          // Building Dropdown
          DropdownButtonFormField<String>(
            value: _selectedBuilding,
            decoration: InputDecoration(
              labelText: 'Tòa nhà',
              labelStyle: GoogleFonts.poppins(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            hint: Text('Chọn tòa nhà', style: GoogleFonts.poppins()),
            items: widget.availableBuildings
                .map((building) => DropdownMenuItem(
              value: building,
              child: Text(building, style: GoogleFonts.poppins()),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedBuilding = value;
              });
            },
          ),

          SizedBox(height: 16),

          // Confirm Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1CAF7D),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (_roomController.text.isNotEmpty && _selectedBuilding != null) {
                widget.onAddressSelected(
                    _roomController.text,
                    _selectedBuilding!
                );
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Vui lòng chọn đầy đủ thông tin phòng và tòa nhà',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              }
            },
            child: Text(
              'Xác nhận',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}