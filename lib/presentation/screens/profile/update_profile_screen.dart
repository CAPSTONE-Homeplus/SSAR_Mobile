import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/domain/entities/building/building.dart';
import 'package:home_clean/domain/entities/house/house.dart';
import 'package:home_clean/domain/entities/user/create_user.dart';
import 'package:home_clean/presentation/blocs/building/building_bloc.dart';
import 'package:home_clean/presentation/blocs/building/building_event.dart';
import 'package:home_clean/presentation/blocs/building/building_state.dart';
import 'package:home_clean/presentation/blocs/house/house_bloc.dart';
import 'package:home_clean/presentation/blocs/house/house_event.dart';
import 'package:home_clean/presentation/blocs/house/house_state.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';
import '../../widgets/bottom_navigation.dart';

class UpdateProfileScreen extends StatefulWidget {
  final CreateUser currentUser;

  const UpdateProfileScreen({Key? key, required this.currentUser})
      : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;

  // Building and House Controllers
  late TextEditingController _buildingController;
  late TextEditingController _houseController;

  // State variables
  List<Building> availableBuildings = [];
  List<House> availableHouses = [];
  Building? selectedBuilding;
  House? selectedHouse;
  bool isHouseLoading = false;

  final Color _primaryColor = AppColors.primaryColor;

  @override
  void initState() {
    super.initState();

    // Initialize user data controllers
    _fullNameController = TextEditingController(
        text: widget.currentUser.fullName ?? ''
    );
    _usernameController = TextEditingController(
        text: widget.currentUser.username ?? ''
    );
    _phoneNumberController = TextEditingController(
        text: widget.currentUser.phoneNumber ?? ''
    );
    _emailController = TextEditingController(
        text: widget.currentUser.email ?? ''
    );

    // Initialize building and house controllers
    _buildingController = TextEditingController(
        text: widget.currentUser.buildingCode ?? 'S102'
    );
    _houseController = TextEditingController(
        text: widget.currentUser.houseCode ?? 'S102'
    );

    // Fetch buildings
    context.read<BuildingBloc>().add(GetBuildings());
  }

  @override
  void dispose() {
    // Dispose all controllers
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _buildingController.dispose();
    _houseController.dispose();
    super.dispose();
  }

  /// Finds and sets default building and house based on user's codes
  void _setDefaultBuildingAndHouse() {
    // First, ensure we have buildings
    if (availableBuildings.isEmpty) return;

    // Find default building
    Building? defaultBuilding;
    if (widget.currentUser.buildingCode != null &&
        widget.currentUser.buildingCode!.isNotEmpty) {
      defaultBuilding = availableBuildings.firstWhere(
            (building) => building.code == widget.currentUser.buildingCode,
        orElse: () => availableBuildings.first, // Fallback to first building
      );
    }

    // If a building is found, update building controller and fetch houses
    if (defaultBuilding != null) {
      setState(() {
        selectedBuilding = defaultBuilding;
        _buildingController.text = defaultBuilding?.name ?? '';
      });

      // Trigger house fetching for the selected building
      context.read<HouseBloc>().add(
          GetHouseByBuilding(buildingId: defaultBuilding.id ?? ''));
    }
  }

  /// Sets default house after houses are loaded
  void _setDefaultHouse() {
    // Ensure we have houses and a selected building
    if (availableHouses.isEmpty || selectedBuilding == null) return;

    // Find default house
    House? defaultHouse;
    if (widget.currentUser.houseCode != null &&
        widget.currentUser.houseCode!.isNotEmpty) {
      defaultHouse = availableHouses.firstWhere(
            (house) => house.code == widget.currentUser.houseCode,
        orElse: () => availableHouses.first, // Fallback to first house
      );
    }

    // Update house controller if a house is found
    if (defaultHouse != null) {
      setState(() {
        selectedHouse = defaultHouse;
        _houseController.text = defaultHouse?.code ?? '';
      });
    }
  }

  void _submitForm() {
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

      // Prepare user update object
      final updatedUser = {
        "fullName": _fullNameController.text,
        "username": _usernameController.text,
        "buildingCode": selectedBuilding?.code ?? '',
        "houseCode": selectedHouse?.code ?? '',
        "phoneNumber": _phoneNumberController.text,
        "email": _emailController.text
      };

      // TODO: Implement update logic using BLoC
      // context.read<ProfileBloc>().add(UpdateProfileEvent(updatedUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Cập Nhật Thông Tin',
          onBackPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BottomNavigation(
                      initialIndex: 2,
                      child: Container(),
                    ),
              ),
            );
          }
      ),
      body: BlocConsumer<BuildingBloc, BuildingState>(
        listener: (context, state) {
          if (state is BuildingLoaded) {
            setState(() {
              availableBuildings = state.buildings.items;
            });

            // Set default building after buildings are loaded
            _setDefaultBuildingAndHouse();
          }
        },
        builder: (context, buildingState) {
          return BlocConsumer<HouseBloc, HouseState>(
            listener: (context, state) {
              if (state is HouseLoaded) {
                setState(() {
                  availableHouses = state.houses.items;
                  isHouseLoading = false;
                });

                // Set default house after houses are loaded
                _setDefaultHouse();
              } else if (state is HouseLoading) {
                setState(() {
                  isHouseLoading = true;
                });
              }
            },
            builder: (context, houseState) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Existing fields...
                      _buildTextField(
                        controller: _fullNameController,
                        label: 'Họ và Tên',
                        icon: Icons.person,
                        validator: (value) =>
                        value!.isEmpty
                            ? 'Vui lòng nhập họ và tên'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _usernameController,
                        label: 'Tên Đăng Nhập',
                        icon: Icons.account_circle,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildBuildingAutocomplete(),
                      const SizedBox(height: 16),
                      isHouseLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildHouseAutocomplete(),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _phoneNumberController,
                        label: 'Số Điện Thoại',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) => _validatePhoneNumber(value),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => _validateEmail(value),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cập Nhật',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Autocomplete for Buildings
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
                building.name!.toLowerCase().contains(
                    textEditingValue.text.toLowerCase()));
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
              context.read<HouseBloc>().add(
                  GetHouseByBuilding(buildingId: selection.id ?? ''));
            });
          },
        ),
      ],
    );
  }

  // Autocomplete for Houses
  Widget _buildHouseAutocomplete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Căn hộ',
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        // Check if a building is selected and no houses are available
        if (selectedBuilding != null && availableHouses.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Không có căn hộ nào trong tòa nhà này',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Autocomplete<House>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (selectedBuilding == null) {
                return const Iterable<House>.empty();
              }

              // If no houses are available, return a special "No houses" option
              if (availableHouses.isEmpty) {
                return [
                  House(
                      id: 'no_houses',
                      code: 'Không có căn hộ',
                      buildingId: selectedBuilding?.id
                  )
                ];
              }

              // Normal filtering when houses are available
              if (textEditingValue.text.isEmpty) {
                return availableHouses;
              }

              return availableHouses.where((house) =>
                  house.code!.toLowerCase().contains(
                      textEditingValue.text.toLowerCase()));
            },
            displayStringForOption: (House option) =>
            option.id == 'no_houses' ? 'Không có căn hộ' : (option.code ?? ''),
            fieldViewBuilder: (context, controller, focusNode,
                onFieldSubmitted) {
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
              if (selection.id == 'no_houses') {
                // Handle the case when "No houses" is selected
                setState(() {
                  selectedHouse = null;
                  _houseController.clear();
                });
              } else {
                setState(() {
                  selectedHouse = selection;
                  _houseController.text = selection.code ?? '';
                });
              }
            },
          ),
      ],
    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false, // Add this parameter
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly, // Apply read-only status
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        // Add a visual indicator for read-only field
        disabledBorder: readOnly
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        )
            : null,
        // Add a slight background color for read-only fields
        fillColor: readOnly ? Colors.grey[100] : null,
        filled: readOnly,
      ),
      keyboardType: keyboardType,
      validator: readOnly ? null : validator, // Disable validation for read-only fields
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    // Regex for Vietnamese phone number
    final phoneRegex = RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }
}