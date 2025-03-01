import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../domain/entities/building/building.dart';

class BuildingFieldWidget extends StatefulWidget {
  final List<Building> availableBuildings;
  final Function(Building) onBuildingSelected;

  const BuildingFieldWidget({
    Key? key,
    required this.availableBuildings,
    required this.onBuildingSelected,
  }) : super(key: key);

  @override
  _BuildingFieldWidgetState createState() => _BuildingFieldWidgetState();
}

class _BuildingFieldWidgetState extends State<BuildingFieldWidget> {
  late TextEditingController _buildingCodeController;

  @override
  void initState() {
    super.initState();
    _buildingCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _buildingCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tên tòa nhà (S1, S2, ...)',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            return widget.availableBuildings
                .where((building) => building.name != null &&
                building.name!.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                .map((building) => building.name!)
                .toList();
          },
          onSelected: (selectedBuildingName) {
            setState(() {
              _buildingCodeController.text = selectedBuildingName;
              final selectedBuilding = widget.availableBuildings.firstWhere(
                      (building) => building.name == selectedBuildingName);
              widget.onBuildingSelected(selectedBuilding);
            });
          },
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            _buildingCodeController = textEditingController;
            return TextFormField(
              controller: _buildingCodeController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Nhập tên tòa nhà',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
                prefixIcon: Icon(Icons.home_outlined, color: const Color(0xFF1CAF7D)),
                filled: true,
                fillColor: Colors.white,
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
              ),
              onEditingComplete: () {
                focusNode.unfocus();
              },
            );
          },
        ),
      ],
    );
  }
}
