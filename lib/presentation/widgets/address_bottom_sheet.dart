import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressBottomSheet extends StatefulWidget {
  final Function(String, String, String) onAddressSelected;
  final String currentAddress;
  final String currentBuilding;
  final String currentRoom;

  const AddressBottomSheet({
    Key? key,
    required this.onAddressSelected,
    required this.currentAddress,
    required this.currentBuilding,
    this.currentRoom = '',
  }) : super(key: key);

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  String selectedBuilding = '';
  bool useDefaultAddress = true;
  final TextEditingController roomController = TextEditingController();
  final List<String> buildings = ['S02', 'S03', 'S04', 'S05'];
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    selectedBuilding = widget.currentBuilding;
    roomController.text = widget.currentRoom;
    useDefaultAddress =
        widget.currentAddress == 'S02-2314, Vinhomes Quận 9, TP. Hồ Chí Minh';
  }

  @override
  void dispose() {
    roomController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool get isValidRoom => roomController.text.length == 4;

  void _handleAddressSelection() {
    if (useDefaultAddress) {
      widget.onAddressSelected(
        'S02-2314, Vinhomes Quận 9, TP. Hồ Chí Minh',
        selectedBuilding,
        '',
      );
      Navigator.pop(context);
    } else if (selectedBuilding.isNotEmpty && isValidRoom) {
      final address =
          '$selectedBuilding-${roomController.text}, Vinhomes Quận 9, TP. Hồ Chí Minh';
      widget.onAddressSelected(
        address,
        selectedBuilding,
        roomController.text,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardVisible = viewInsets.bottom > 0;

    return Padding(
      padding: viewInsets,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDefaultAddress(),
                    const Divider(height: 1),
                    if (!useDefaultAddress) ...[
                      _buildBuildingSelection(),
                      if (selectedBuilding.isNotEmpty) _buildRoomInput(),
                    ],
                    if (isKeyboardVisible) SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Color(0xFF1CAF7D)),
          const SizedBox(width: 12),
          Text(
            'Chọn địa chỉ khác',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            splashRadius: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAddress() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Địa chỉ mặc định',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              setState(() {
                useDefaultAddress = true;
                selectedBuilding = '';
                roomController.clear();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: useDefaultAddress
                      ? const Color(0xFF1CAF7D)
                      : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.home_outlined, color: Color(0xFF1CAF7D)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nhà',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Vinhomes Quận 9, TP. Hồ Chí Minh',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Radio<bool>(
                    value: true,
                    groupValue: useDefaultAddress,
                    onChanged: (value) {
                      setState(() {
                        useDefaultAddress = true;
                        selectedBuilding = '';
                        roomController.clear();
                      });
                    },
                    activeColor: const Color(0xFF1CAF7D),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              setState(() {
                useDefaultAddress = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: !useDefaultAddress
                      ? const Color(0xFF1CAF7D)
                      : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_location_outlined,
                      color: Color(0xFF1CAF7D)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Chọn địa chỉ khác',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Radio<bool>(
                    value: false,
                    groupValue: useDefaultAddress,
                    onChanged: (value) {
                      setState(() {
                        useDefaultAddress = false;
                      });
                    },
                    activeColor: const Color(0xFF1CAF7D),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuildingSelection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chọn tòa nhà',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: buildings.length,
            itemBuilder: (context, index) {
              final building = buildings[index];
              final isSelected = selectedBuilding == building;

              return InkWell(
                onTap: () {
                  setState(() {
                    selectedBuilding = building;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1CAF7D) : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1CAF7D)
                          : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      building,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoomInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Số phòng',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: roomController,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            maxLength: 4,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              hintText: 'Nhập 4 số phòng',
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1CAF7D)),
              ),
              prefixIcon: const Icon(Icons.door_front_door_outlined),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    final bool canConfirm =
        useDefaultAddress || (selectedBuilding.isNotEmpty && isValidRoom);

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
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
          onPressed: canConfirm ? _handleAddressSelection : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1CAF7D),
            disabledBackgroundColor: Colors.grey[300],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'Xác nhận',
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
