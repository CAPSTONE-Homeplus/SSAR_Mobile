import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/blocs/building/building_state.dart';
import 'package:home_clean/presentation/blocs/house/house_bloc.dart';
import 'package:home_clean/presentation/blocs/house/house_event.dart';


import '../../../domain/entities/building/building.dart';
import '../../../domain/entities/house/house.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/building/building_bloc.dart';
import '../../blocs/building/building_event.dart';
import 'components/building_field.dart';
import 'components/house_field.dart';
import 'components/register_button.dart';

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
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Registration successful!'),
          //     backgroundColor: Colors.green,
          //   ),
          // );
          Navigator.of(context).pop();
        }
        // else if (state is RegisterFailed) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(state.error),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        // }
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
        _buildingBloc.add(GetBuildings(search: '', orderBy: ''));
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
          availableBuildings = state.buildings.items;
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
          BuildingFieldWidget(
            availableBuildings: availableBuildings,
            onBuildingSelected: (selectedBuilding) {
              setState(() {
                selectedBuildingObj = selectedBuilding;
                _buildingCodeController.text = selectedBuilding.name!;
                _houseCodeController.clear();
                selectedHouseObj = House(id: '', code: '', buildingId: '');
              });
              _fetchHouseList(context, selectedBuilding.name ?? '');
            },
          ),

          const SizedBox(height: 16),
          HouseCodeFieldWidget(
            houseCodeController: _houseCodeController,
            houseBloc: context.read<HouseBloc>(),
            onHouseSelected: (selectedHouse) {
              setState(() {
                selectedHouseObj = selectedHouse;
              });
            },
          ),
          const SizedBox(height: 32),
          RegisterButton(
            formKey: _formKey,
            fullNameController: _fullNameController,
            usernameController: _usernameController,
            passwordController: _passwordController,
            buildingCode: selectedBuildingObj.code ?? '',
            houseCode: selectedHouseObj.code ?? '',
          ),
          const SizedBox(height: 24),
          _buildLoginLink(),
        ],
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