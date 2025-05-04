import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/core/router/app_router.dart';
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
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
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
  late CreateUser createUser;
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _buildingController;
  late TextEditingController _houseController;
  List<Building> availableBuildings = [];
  List<House> availableHouses = [];
  Building? selectedBuilding;
  House? selectedHouse;
  bool isHouseLoading = false;
  final Color _primaryColor = AppColors.primaryColor;

  @override
  void initState() {
    super.initState();
    _fullNameController =
        TextEditingController(text: widget.currentUser.fullName ?? '');
    _usernameController =
        TextEditingController(text: widget.currentUser.username ?? '');
    _phoneNumberController =
        TextEditingController(text: widget.currentUser.phoneNumber ?? '');
    _emailController =
        TextEditingController(text: widget.currentUser.email ?? '');

    _buildingController =
        TextEditingController(text: widget.currentUser.buildingCode ?? '');
    _houseController =
        TextEditingController(text: widget.currentUser.houseCode ?? '');
    context.read<BuildingBloc>().add(GetBuildings());
  }


  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _buildingController.dispose();
    _houseController.dispose();
    super.dispose();
  }

  void _setDefaultBuilding() {
    if (availableBuildings.isEmpty) return;

    Building? defaultBuilding = _findDefaultBuilding();
    if (defaultBuilding != null) {
      _updateSelectedBuilding(defaultBuilding);
      _fetchHousesForBuilding(defaultBuilding);
    }
  }

  Building? _findDefaultBuilding() {
    if (widget.currentUser.buildingCode == null ||
        widget.currentUser.buildingCode!.isEmpty) {
      return availableBuildings.first;
    }

    return availableBuildings.firstWhere(
      (building) => building.code == widget.currentUser.buildingCode,
      orElse: () => availableBuildings.first,
    );
  }

  void _updateSelectedBuilding(Building building) {
    setState(() {
      selectedBuilding = building;
      _buildingController.text = building.name ?? '';
    });
  }

  void _fetchHousesForBuilding(Building building) {
    context.read<HouseBloc>().add(
          GetHouseByBuilding(buildingId: building.id ?? ''),
        );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      if (selectedBuilding == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vui lòng chọn tòa nhà'),
            backgroundColor: Colors.black,
          ),
        );
        return;
      }

      // if (selectedHouse == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Vui lòng chọn căn hộ'),
      //       backgroundColor: Colors.black,
      //     ),
      //   );
      //   return;
      // }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: _primaryColor,
          ),
        ),
      );

      context.read<UserBloc>().add(UpdateProfileEvent(
        fullName: _fullNameController.text,
        username: widget.currentUser.username,
        buildingCode: selectedBuilding?.code ?? '',
        houseCode: selectedHouse?.code,
        phoneNumber: _phoneNumberController.text,
        email: _emailController.text,
      ));

      context.read<UserBloc>().stream.listen((state) {
        if (state is UserUpdateSuccess) {
          Get.back();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigation(
                initialIndex: 3,
                child: Container(),
              ),
            ),
          );
        } else if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Cập Nhật Thông Tin',
          onBackPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigation(
                  initialIndex: 3,
                  child: Container(),
                ),
              ),
                  (Route<dynamic> route) => false,
            );
          }),
      body: BlocConsumer<BuildingBloc, BuildingState>(
        listener: (context, state) {
          if (state is BuildingLoaded) {
            setState(() {
              availableBuildings = state.buildings.items;
            });
            _setDefaultBuilding();
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
                      _buildTextField(
                        controller: _fullNameController,
                        label: 'Họ và Tên',
                        icon: Icons.person,
                        validator: (value) =>
                            value!.isEmpty ? 'Vui lòng nhập họ và tên' : null,
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
                      _buildHouseAutocomplete(),
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
          initialValue: TextEditingValue(text: _buildingController.text),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<Building>.empty();
            }
            return availableBuildings.where(
                  (building) =>
                  building.name!.toLowerCase().contains(textEditingValue.text.toLowerCase()),
            );
          },
          displayStringForOption: (Building option) => option.name ?? '',
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            controller.text = _buildingController.text;
            controller.addListener(() {
              _buildingController.text = controller.text;
            });

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
              onSubmitted: (value) {
                // Nếu chỉ có một kết quả khớp, chọn luôn
                final matchedBuildings = availableBuildings.where(
                      (building) => building.name!.toLowerCase().contains(value.toLowerCase()),
                ).toList();

                if (matchedBuildings.length == 1) {
                  setState(() {
                    selectedBuilding = matchedBuildings.first;
                    _buildingController.text = matchedBuildings.first.name ?? '';

                    // Reset house-related fields
                    selectedHouse = null;
                    _houseController.clear();
                    availableHouses = [];

                    // Fetch houses cho tòa nhà mới
                    context.read<HouseBloc>().add(
                      GetHouseByBuilding(buildingId: matchedBuildings.first.id ?? ''),
                    );
                  });

                  // Di chuyển focus sang field tiếp theo
                  FocusScope.of(context).nextFocus();
                } else if (matchedBuildings.isEmpty) {
                  // Hiển thị thông báo nếu không tìm thấy
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Không tìm thấy tòa nhà phù hợp')),
                  );
                }
              },
            );
          },
          onSelected: (Building selection) {
            setState(() {
              selectedBuilding = selection;
              _buildingController.text = selection.name ?? '';

              // Reset house-related fields
              selectedHouse = null;
              _houseController.clear();
              availableHouses = [];

              // Fetch houses cho tòa nhà mới
              context.read<HouseBloc>().add(
                GetHouseByBuilding(buildingId: selection.id ?? ''),
              );
            });
          },
        ),
      ],
    );
  }

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
          initialValue: TextEditingValue(text: _houseController.text),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<House>.empty();
            }

            return availableHouses.where(
                  (house) =>
              (house.code?.toLowerCase().contains(textEditingValue.text.toLowerCase()) ?? false) ||
                  (house.no?.toLowerCase().contains(textEditingValue.text.toLowerCase()) ?? false),
            );
          },
          displayStringForOption: (House option) => option.code ?? '',
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            controller.text = _houseController.text;
            controller.addListener(() {
              _houseController.text = controller.text;
            });

            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Nhập tên căn hộ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: Icon(Icons.apartment, color: _primaryColor),
              ),
              onSubmitted: (value) {
                // Nếu chỉ có một kết quả khớp, chọn luôn
                final matchedHouses = availableHouses.where(
                      (house) =>
                  (house.code?.toLowerCase().contains(value.toLowerCase()) ?? false) ||
                      (house.no?.toLowerCase().contains(value.toLowerCase()) ?? false),
                ).toList();

                if (matchedHouses.length == 1) {
                  setState(() {
                    selectedHouse = matchedHouses.first;
                    _houseController.text = matchedHouses.first.code ?? '';
                  });

                  // Di chuyển focus sang field tiếp theo
                  FocusScope.of(context).nextFocus();
                } else if (matchedHouses.isEmpty) {
                  // Hiển thị thông báo nếu không tìm thấy
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Không tìm thấy căn hộ phù hợp')),
                  );
                }
              },
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) {
        if (!readOnly && validator != null) {
          _submitForm();
        }
        onSubmitted?.call();
      },
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
        disabledBorder: readOnly
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              )
            : null,
        fillColor: readOnly ? Colors.grey[100] : null,
        filled: readOnly,
      ),
      keyboardType: keyboardType,
      validator: readOnly ? null : validator,
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
