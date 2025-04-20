import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_event.dart';
import '../../../blocs/user/user_state.dart';
import '../../../widgets/show_dialog.dart';

class AccountInfoScreen extends StatefulWidget {
  final String username;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String buildingCode;
  final String houseCode;
  final String citizenCode;
  final Function(
      String fullName,
      String phoneNumber,
      String email,
      String buildingCode,
      String houseCode,
      String username,
      String password,
      String citizenCode,
      ) onRegister;

  final Function() onBack;

  const AccountInfoScreen({
    super.key,
    required this.username,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.buildingCode,
    required this.houseCode,
    required this.onRegister,
    required this.citizenCode,
    required this.onBack,
  });

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final Color _primaryColor = const Color(0xFF1CAF7D);
  bool _isCheckingUser = false;
  bool _isRegistering = false;

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isCheckingUser = true;
      });

      context.read<UserBloc>().add(
        CheckUserInfoEvent(username: _usernameController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Thông tin tài khoản',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        leading: BackButton(onPressed: widget.onBack),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  (AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).viewInsets.bottom),
            ),
            child: MultiBlocListener(
              listeners: [
                BlocListener<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is CheckUserInfoSuccess) {
                      setState(() {
                        _isCheckingUser = false;
                        _isRegistering = true;
                      });

                      context.read<AuthBloc>().add(
                        RegisterAccount(
                          fullName: widget.fullName,
                          username: _usernameController.text,
                          password: _passwordController.text,
                          buildingCode: widget.buildingCode,
                          houseCode: widget.houseCode,
                          phoneNumber: widget.phoneNumber,
                          email: widget.email,
                          citizenCode: widget.citizenCode,
                        ),
                      );
                    } else if (state is UserError) {
                      setState(() {
                        _isCheckingUser = false;
                      });

                      showCustomDialog(
                        context: context,
                        message: state.message,
                        type: DialogType.error,
                      );
                    }
                  },
                ),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is RegisterSuccess) {
                      setState(() {
                        _isRegistering = false;
                      });

                      AppRouter.navigateToRegisterSuccess();
                    } else if (state is RegisterFailed) {
                      setState(() {
                        _isRegistering = false;
                      });

                      showCustomDialog(
                        context: context,
                        message: state.error,
                        type: DialogType.error,
                      );
                    }
                  },
                ),
              ],
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Bước 3/3: Tạo tài khoản',
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 24),
                        _buildTextField(
                          controller: _usernameController,
                          label: 'Tên đăng nhập',
                          hint: 'Nhập tên đăng nhập',
                          icon: Icons.account_circle_outlined,
                          validator: (value) {
                            if (value?.isEmpty ?? true) return 'Vui lòng nhập tên đăng nhập';
                            if ((value?.length ?? 0) < 4) return 'Tên đăng nhập phải có ít nhất 4 ký tự';
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
                          onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                          validator: (value) {
                            if (value?.isEmpty ?? true) return 'Vui lòng nhập mật khẩu';
                            if ((value?.length ?? 0) < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
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
                          onTogglePassword: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          validator: (value) {
                            if (value != _passwordController.text) return 'Mật khẩu không khớp';
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isCheckingUser || _isRegistering ? null : _onRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isCheckingUser || _isRegistering
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Đăng ký',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
    Function()? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: _primaryColor),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
              onPressed: onTogglePassword,
            )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
