import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/constant.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/blocs/building/building_state.dart';
import 'package:home_clean/presentation/blocs/house/house_bloc.dart';
import 'package:home_clean/presentation/blocs/house/house_event.dart';
import 'package:home_clean/presentation/blocs/house/house_state.dart';


import '../../../domain/entities/building/building.dart';
import '../../../domain/entities/house/house.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/building/building_bloc.dart';
import '../../blocs/building/building_event.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(); // Navigate back to login
        } else if (state is RegisterFailed) {
          AppRouter.navigateToLogin();
        }
      },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    const RegisterFormContent(),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'Đăng ký tài khoản',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1CAF7D),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Hãy điền thông tin của bạn để tạo tài khoản',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class RegisterFormContent extends StatefulWidget {
  const RegisterFormContent({super.key});

  @override
  State<RegisterFormContent> createState() => _RegisterFormContentState();
}

class _RegisterFormContentState extends State<RegisterFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _houseCodeController = TextEditingController();
  var _buildingCodeController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late List<House> availableHomes = [];
  late List<Building> availableBuildings = [];
  late BuildingBloc _buildingBloc;
  bool isLoading = true;
  late Building selectedBuildingObj = Building(id: '', code: '', name: '');
  late House selectedHouseObj = House(id: '', code: '', buildingId: '');

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _houseCodeController.dispose();
    _buildingCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        setState(() {
          isLoading = true;
        });
        _buildingBloc = context.read<BuildingBloc>();
        _buildingBloc.add(GetBuildings(search: '', orderBy: '', page: Constant.defaultPage, size: Constant.defaultSize));
        final buildingComplete = _processBuildings();
        await Future.wait([
          buildingComplete
        ]);
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void _fetchHouseList(BuildContext context, String buildingName) {
    final building = availableBuildings.firstWhere(
          (b) => b.name == buildingName,
      orElse: () => Building(id: "", name: ""),
    );

    if (building.id != "") {
      context.read<HouseBloc>().add(GetHouseByBuilding(
        buildingId: building.id ?? ""
      ));

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không tìm thấy tòa nhà: $buildingName")),
      );
    }
  }


  Future<void> _processBuildings() async {
    await for (final state in _buildingBloc.stream) {
      if (state is BuildingLoaded && mounted) {
        setState(() {
          availableBuildings = state.buildings.map((building) => building).toList();
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _fullNameController,
            label: 'Họ và tên',
            hint: 'Nhập tên đầy đủ của bạn',
            icon: Icons.person_outline,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Vui lòng nhập tên đầy đủ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _usernameController,
            label: 'Tên đăng nhập',
            hint: 'Nhập tên đăng nhập',
            icon: Icons.account_circle_outlined,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Vui lòng nhập tên đăng nhập';
              }
              if ((value?.length ?? 0) < 4) {
                return 'Tên đăng nhập phải có ít nhất 4 ký tự';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            label: 'Mật khẩu',
            hint: 'Nhập mật khẩu của bạn',
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscurePassword,
            onTogglePassword: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Vui lòng nhập mật khẩu';
              }
              if ((value?.length ?? 0) < 6) {
                return 'Mật khẩu phải có ít nhất 6 ký tự';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _confirmPasswordController,
            label: 'Xác nhận mật khẩu',
            hint: 'Nhập lại mật khẩu của bạn',
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: _obscureConfirmPassword,
            onTogglePassword: () {
              setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
            },
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Mật khẩu không khớp';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildBuildingField(context),
          const SizedBox(height: 16),
          _buildHouseCodeField(context),
          const SizedBox(height: 32),
          _buildRegisterButton(context),
          const SizedBox(height: 24),
          _buildLoginLink(),
        ],
      ),
    );
  }

  Widget _buildBuildingField(BuildContext context) {
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
            return availableBuildings
                .where((building) => building.name != null &&
                building.name!.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                .map((building) => building.name!)
                .toList();
          },
          onSelected: (selectedBuildingName) {
            setState(() {
              _buildingCodeController.text = selectedBuildingName;
              selectedBuildingObj = availableBuildings.firstWhere(
                      (building) => building.name == selectedBuildingName);
              _houseCodeController.clear(); // Clear house selection when building changes
              selectedHouseObj = House(id: '', code: '', buildingId: '');
            });
            _fetchHouseList(context, selectedBuildingObj.name ?? '');
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
                if (_buildingCodeController.text.isNotEmpty) {
                  _fetchHouseList(context, _buildingCodeController.text);
                }
                focusNode.unfocus();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildHouseCodeField(BuildContext context) {
    return BlocBuilder<HouseBloc, HouseState>(
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
                  setState(() {
                    _houseCodeController.text = selectedHouse;
                    selectedHouseObj = state.houses.items.firstWhere(
                            (house) => house.code == selectedHouse);
                  });
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
      enabled: controller != null, // Disable when loading or error
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
        // Thêm helper text khi không có data
        helperText: controller != null && controller.text.isEmpty ?
        'Không tìm thấy căn hộ trong tòa nhà này' : null,
        helperStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && obscureText,
          validator: validator,
          style: GoogleFonts.poppins(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey[400],
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF1CAF7D)),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: onTogglePassword,
            )
                : null,
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
        ),
      ],
    );
  }
  Widget _buildRegisterButton(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    String? errorMessage;

    if (state is RegisterFailed) {
      errorMessage = state.error;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ElevatedButton(
          onPressed: state is AuthenticationLoading
              ? null
              : () {
            if (_formKey.currentState?.validate() ?? false) {
              context.read<AuthBloc>().add(
                RegisterAccount(
                  fullName: _fullNameController.text,
                  username: _usernameController.text,
                  password: _passwordController.text,
                  buildingCode: selectedBuildingObj.code ?? '',
                  houseCode: selectedHouseObj.code ?? '',
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1CAF7D),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: state is AuthenticationLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
            'Đăng ký',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Đã có tài khoản?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Đăng nhập',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1CAF7D),
            ),
          ),
        ),
      ],
    );
  }
}