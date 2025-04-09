// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../../domain/entities/building/building.dart';
// import '../../../blocs/building/building_bloc.dart';
// import '../../../blocs/building/building_event.dart';
// import '../../../blocs/building/building_state.dart';
// import '../../../blocs/house/house_bloc.dart';
// import '../../../blocs/house/house_event.dart';
// import '../../../blocs/house/house_state.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../../domain/entities/building/building.dart';
// import '../../../blocs/building/building_bloc.dart';
// import '../../../blocs/building/building_event.dart';
// import '../../../blocs/building/building_state.dart';
// import '../../../blocs/house/house_bloc.dart';
// import '../../../blocs/house/house_event.dart';
// import '../../../blocs/house/house_state.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../../domain/entities/building/building.dart';
// import '../../../blocs/building/building_bloc.dart';
// import '../../../blocs/building/building_event.dart';
// import '../../../blocs/building/building_state.dart';
// import '../../../blocs/house/house_bloc.dart';
// import '../../../blocs/house/house_event.dart';
// import '../../../blocs/house/house_state.dart';
//
// class AddressSelectionBottomSheet extends StatefulWidget {
//   final String? currentRoom;
//   final String? currentBuilding;
//   final Function(String room, String building) onAddressSelected;
//
//   const AddressSelectionBottomSheet({
//     Key? key,
//     this.currentRoom,
//     this.currentBuilding,
//     required this.onAddressSelected,
//   }) : super(key: key);
//
//   @override
//   _AddressSelectionBottomSheetState createState() => _AddressSelectionBottomSheetState();
// }
//
// class _AddressSelectionBottomSheetState extends State<AddressSelectionBottomSheet> {
//   late TextEditingController _roomController;
//   String? _selectedBuilding;
//   String? _selectedBuildingId;
//
//   @override
//   void initState() {
//     super.initState();
//     _roomController = TextEditingController(text: widget.currentRoom ?? '');
//     _selectedBuilding = widget.currentBuilding;
//     // Trigger the loading of buildings
//     context.read<BuildingBloc>().add(GetBuildings());
//   }
//
//   @override
//   void dispose() {
//     _roomController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: SingleChildScrollView(
//         child: BlocBuilder<BuildingBloc, BuildingState>(
//           builder: (context, state) {
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Chọn địa chỉ',
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//
//                 // Building Dropdown with different states
//                 if (state is BuildingLoading) ...[
//                   Center(child: CircularProgressIndicator(color: Color(0xFF1CAF7D))),
//                 ] else if (state is BuildingError) ...[
//                   Text(
//                     'Không thể tải danh sách tòa nhà. Vui lòng thử lại.',
//                     style: GoogleFonts.poppins(color: Colors.red),
//                   ),
//                   SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<BuildingBloc>().add(GetBuildings());
//                     },
//                     child: Text('Thử lại', style: GoogleFonts.poppins()),
//                   ),
//                 ] else if (state is BuildingLoaded) ...[
//                   Builder(
//                     builder: (context) {
//                       // Thay thế đoạn dùng Set<Building>
//                       final Map<String?, Building> buildingMap = {};
//                       for (final building in state.buildings.items) {
//                         if (building.id != null && building.name != null) {
//                           buildingMap[building.name] = building; // nếu bạn muốn lọc theo name
//                         }
//                       }
//                       final deduplicatedBuildings = buildingMap.values.toList();
//
//                       // Check if the currently selected building exists in the loaded buildings
//                       final buildingExists = _selectedBuilding == null ? false :
//                       deduplicatedBuildings.any((building) => building.name == _selectedBuilding);
//
//                       // If the selected building doesn't exist in the list, reset it
//                       if (!buildingExists && _selectedBuilding != null) {
//                         // Schedule a microtask to avoid changing state during build
//                         Future.microtask(() => setState(() {
//                           _selectedBuilding = null;
//                           _selectedBuildingId = null;
//                         }));
//                       }
//
//                       return DropdownButtonFormField<String>(
//                         value: buildingExists ? _selectedBuilding : null,
//                         decoration: InputDecoration(
//                           labelText: 'Tòa nhà',
//                           labelStyle: GoogleFonts.poppins(),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         hint: Text('Chọn tòa nhà', style: GoogleFonts.poppins()),
//                         items: deduplicatedBuildings.map((Building building) {
//                           final name = building.name ?? '';
//                           return DropdownMenuItem<String>(
//                             value: name,
//                             child: Text(name, style: GoogleFonts.poppins()),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           // Find the selected building to get its ID
//                           final selectedBuildingObj = deduplicatedBuildings.firstWhere(
//                                 (building) => building.name == value,
//                             orElse: () => Building(),
//                           );
//
//                           setState(() {
//                             _selectedBuilding = value;
//                             _selectedBuildingId = selectedBuildingObj.id;
//                           });
//
//                           // Fetch houses for the selected building
//                           if (selectedBuildingObj.id != null && selectedBuildingObj.id!.isNotEmpty) {
//                             context.read<HouseBloc>().add(
//                                 GetHouseByBuilding(buildingId: selectedBuildingObj.id!)
//                             );
//                           }
//                         },
//                       );
//                     },
//                   ),
//                 ] else ...[
//                   // Initial state or any other state
//                   DropdownButtonFormField<String>(
//                     value: null,
//                     decoration: InputDecoration(
//                       labelText: 'Tòa nhà',
//                       labelStyle: GoogleFonts.poppins(),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     hint: Text('Đang tải danh sách tòa nhà...', style: GoogleFonts.poppins()),
//                     items: const [],
//                     onChanged: null,
//                   ),
//                 ],
//
//                 SizedBox(height: 16),
//
//                 // Room/House Selection
//                 BlocBuilder<HouseBloc, HouseState>(
//                   builder: (context, houseState) {
//                     if (houseState is HouseLoading) {
//                       return Center(
//                         child: Column(
//                           children: [
//                             CircularProgressIndicator(color: Color(0xFF1CAF7D)),
//                             SizedBox(height: 8),
//                             Text(
//                               'Đang tải danh sách căn hộ...',
//                               style: GoogleFonts.poppins(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                       );
//                     } else if (houseState is HouseError) {
//                       return Column(
//                         children: [
//                           Text(
//                             'Không thể tải danh sách căn hộ. Vui lòng thử lại.',
//                             style: GoogleFonts.poppins(color: Colors.red),
//                           ),
//                           SizedBox(height: 8),
//                           // Fallback to manual room input
//                           TextField(
//                             controller: _roomController,
//                             decoration: InputDecoration(
//                               labelText: 'Số phòng',
//                               labelStyle: GoogleFonts.poppins(),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             keyboardType: TextInputType.number,
//                           ),
//                         ],
//                       );
//                     } else if (houseState is HouseLoaded && houseState.houses.items.isNotEmpty) {
//                       // If houses are loaded, show a dropdown to select from
//                       return DropdownButtonFormField<String>(
//                         value: null,
//                         decoration: InputDecoration(
//                           labelText: 'Căn hộ',
//                           labelStyle: GoogleFonts.poppins(),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         hint: Text('Chọn căn hộ', style: GoogleFonts.poppins()),
//                         items: houseState.houses.items.map((house) {
//                           return DropdownMenuItem<String>(
//                             value: house.numberOfRoom,
//                             child: Text(
//                               house.numberOfRoom ?? 'Không có số phòng',
//                               style: GoogleFonts.poppins(),
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             _roomController.text = value ?? '';
//                           });
//                         },
//                       );
//                     } else {
//                       // Default to manual input if no houses are available
//                       return TextField(
//                         controller: _roomController,
//                         decoration: InputDecoration(
//                           labelText: 'Số phòng',
//                           labelStyle: GoogleFonts.poppins(),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         keyboardType: TextInputType.number,
//                       );
//                     }
//                   },
//                 ),
//
//                 SizedBox(height: 16),
//
//                 // Confirm Button
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF1CAF7D),
//                     minimumSize: Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onPressed: (state is BuildingLoaded) ? () {
//                     if (_roomController.text.isNotEmpty && _selectedBuilding != null) {
//                       widget.onAddressSelected(
//                           _roomController.text,
//                           _selectedBuilding!
//                       );
//                       Navigator.of(context).pop();
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             'Vui lòng chọn đầy đủ thông tin phòng và tòa nhà',
//                             style: GoogleFonts.poppins(),
//                           ),
//                         ),
//                       );
//                     }
//                   } : null, // Disable button if buildings aren't loaded
//                   child: Text(
//                     'Xác nhận',
//                     style: GoogleFonts.poppins(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }