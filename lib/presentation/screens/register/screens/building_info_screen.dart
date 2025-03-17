import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/presentation/blocs/house/house_event.dart';
import '../../../../domain/entities/building/building.dart';
import '../../../../domain/entities/house/house.dart';
import '../../../../presentation/blocs/building/building_bloc.dart';
import '../../../blocs/building/building_event.dart';
import '../../../blocs/building/building_state.dart';
import '../../../blocs/house/house_bloc.dart';
import '../../../blocs/house/house_state.dart';

class BuildingInfoScreen extends StatefulWidget {
  final String fullName;
  final String phoneNumber;
  final String email;
  final Function(String fullName, String phoneNumber, String email, String buildingCode, String houseCode) onNext;
  final Function() onBack;

  const BuildingInfoScreen({
    super.key,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<BuildingInfoScreen> createState() => _BuildingInfoScreenState();
}

class _BuildingInfoScreenState extends State<BuildingInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final Color _primaryColor = const Color(0xFF1CAF7D);

  List<Building> availableBuildings = [];
  List<House> availableHouses = [];

  Building? selectedBuilding;
  House? selectedHouse;
  bool isHouseLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<BuildingBloc>().add(GetBuildings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông tin tòa nhà',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        leading: BackButton(onPressed: widget.onBack),
      ),
      body: BlocConsumer<BuildingBloc, BuildingState>(
        listener: (context, state) {
          if (state is BuildingLoaded) {
            setState(() {
              availableBuildings = state.buildings.items;
            });
          } else if (state is BuildingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is BuildingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Bước 2/3: Thông tin tòa nhà',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),
                  _buildBuildingAutocomplete(),
                  const SizedBox(height: 16),
                  BlocConsumer<HouseBloc, HouseState>(
                    listener: (context, state) {
                      if (state is HouseLoaded) {
                        setState(() {
                          availableHouses = state.houses.items;
                          isHouseLoading = false;
                          // Reset selected house when loading new houses
                          selectedHouse = null;
                          _houseController.clear();
                        });
                      } else if (state is HouseError) {
                        setState(() {
                          isHouseLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      } else if (state is HouseLoading) {
                        setState(() {
                          isHouseLoading = true;
                        });
                      }
                    },
                    builder: (context, state) {
                      return isHouseLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildHouseAutocomplete();
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (selectedBuilding == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vui lòng chọn tòa nhà')),
                          );
                          return;
                        }
                        if (selectedHouse == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vui lòng chọn căn hộ')),
                          );
                          return;
                        }

                        widget.onNext(
                          widget.fullName,
                          widget.phoneNumber,
                          widget.email,
                          selectedBuilding!.code ?? '',
                          selectedHouse!.code ?? '',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Tiếp tục',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🔹 Autocomplete cho tòa nhà
  Widget _buildBuildingAutocomplete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tòa nhà',
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Autocomplete<Building>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<Building>.empty();
            }
            return availableBuildings.where((building) =>
                building.name!.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          displayStringForOption: (Building option) => option.name ?? '',
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            _buildingController.text = controller.text;
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Nhập tên tòa nhà",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: Icon(Icons.apartment, color: _primaryColor),
              ),
            );
          },
          onSelected: (Building selection) {
            setState(() {
              selectedBuilding = selection;
              _buildingController.text = selection.name ?? '';
              // Fetch houses for the selected building
              context.read<HouseBloc>().add(GetHouseByBuilding(buildingId: selection.id ?? ''));
            });
          },
        ),
      ],
    );
  }

  /// 🔹 Autocomplete cho căn hộ
  Widget _buildHouseAutocomplete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Căn hộ',
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Autocomplete<House>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty || selectedBuilding == null) {
              return const Iterable<House>.empty();
            }
            return availableHouses.where((house) =>
                house.code!.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          displayStringForOption: (House option) => option.code ?? '',
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            _houseController.text = controller.text;
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Nhập mã căn hộ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: Icon(Icons.home, color: _primaryColor),
              ),
            );
          },
          onSelected: (House selection) {
            setState(() {
              selectedHouse = selection;
              _houseController.text = selection.code ?? '';
            });
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _buildingController.dispose();
    _houseController.dispose();
    super.dispose();
  }
}