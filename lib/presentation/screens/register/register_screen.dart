import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/presentation/blocs/building/building_state.dart';
import 'package:home_clean/presentation/blocs/house/house_bloc.dart';
import 'package:home_clean/presentation/blocs/house/house_event.dart';


import '../../../domain/entities/building/building.dart';
import '../../../domain/entities/house/house.dart';
import '../../blocs/auth/auth_bloc.dart';
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
          Navigator.of(context).pop();
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
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
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
          _buildTextField(
            controller: _phoneNumberController,
            label: 'Số điện thoại',
            hint: 'Nhập số điện thoại của bạn',
            icon: Icons.phone_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số điện thoại';
              }
              // Regex chấp nhận số có đầu +84 hoặc số 9, 10, 11 chữ số
              if (!RegExp(r'^(?:\+84\d{9,10}|\d{9,11})$').hasMatch(value)) {
                return 'Số điện thoại không hợp lệ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Nhập email của bạn',
            icon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Email không hợp lệ';
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
            phoneNumberController: _phoneNumberController,
            emailController: _emailController,
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
    TextInputType? keyboardType,
    bool? enabled,
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
          enabled: enabled ?? true,
          keyboardType: keyboardType ?? _determineKeyboardType(label),
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: enabled ?? true ? Colors.black87 : Colors.grey,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey[400],
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF1CAF7D)),
            prefix: label.contains('Số điện thoại')
                ? Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                '+84 ',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
                : null,
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
            fillColor: enabled ?? true ? Colors.white : Colors.grey[100],
            border: _buildOutlinedBorder(Colors.grey[200]!),
            enabledBorder: _buildOutlinedBorder(Colors.grey[200]!),
            focusedBorder: _buildOutlinedBorder(const Color(0xFF1CAF7D)),
            disabledBorder: _buildOutlinedBorder(Colors.grey[300]!),
          ),
        ),
      ],
    );
  }

// Helper method to determine keyboard type based on label
  TextInputType _determineKeyboardType(String label) {
    final lowercaseLabel = label.toLowerCase();
    if (lowercaseLabel.contains('email')) return TextInputType.emailAddress;
    if (lowercaseLabel.contains('điện thoại') || lowercaseLabel.contains('phone')) {
      return TextInputType.phone;
    }
    if (lowercaseLabel.contains('number')) return TextInputType.number;
    return TextInputType.text;
  }

// Helper method to create consistent outlined border
  OutlineInputBorder _buildOutlinedBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor),
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