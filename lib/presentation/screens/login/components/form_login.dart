import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/internet/internet_bloc.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key, required this.fem, required this.hem, required this.ffem});

  final double fem;
  final double hem;
  final double ffem;

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  final Color _primaryColor = const Color(0xFF1CAF7D);
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticationSuccess) {
          AppRouter.navigateToHome();
        } else if (state is AuthenticationFailed) {
          setState(() {
            _isLoading = false;
            _errorMessage = state.error;
          });
        } else if (state is AuthenticationLoading) {
          setState(() {
            _isLoading = true;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLoginForm(),
            if (_errorMessage != null)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 14),
                ),
              ),
            SizedBox(height: 6 * widget.hem),
            _buildLoginButton(),
            SizedBox(height: 16 * widget.hem),
            _buildDivider(),
            SizedBox(height: 8 * widget.hem),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _userNameController,
          hint: 'Tên đăng nhập',
          icon: Icons.person_outline,
          validator: (value) => value?.isEmpty == true ? 'Tên đăng nhập không được để trống' : null,
        ),
        SizedBox(height: 16 * widget.hem),
        _buildTextField(
          controller: _passwordController,
          hint: 'Mật khẩu',
          icon: Icons.lock_outline,
          isPassword: true,
          validator: (value) => value?.isEmpty == true ? 'Mật khẩu không được để trống' : null,
        ),
        SizedBox(height: 8 * widget.hem),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              AppRouter.navigateToForgotPassword();
            },
            child: Text('Quên mật khẩu?', style: GoogleFonts.poppins(fontSize: 14 * widget.ffem, color: _primaryColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscureText,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 15 * widget.ffem),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 15 * widget.ffem, color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: _primaryColor),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12 * widget.fem), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () {
        if (context.read<InternetBloc>().state is Connected) {
          if (_formKey.currentState!.validate()) {
            context.read<AuthBloc>().add(
              LoginAccount(
                username: _userNameController.text.trim(),
                password: _passwordController.text,
              ),
            );
          }
        } else {
          setState(() {
            _errorMessage = 'Không có kết nối Internet!';
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        padding: EdgeInsets.symmetric(vertical: 16 * widget.hem),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12 * widget.fem)),
      ),
      child: _isLoading
          ? SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 2,
        ),
      )
          : Text(
        'Đăng nhập',
        style: GoogleFonts.poppins(fontSize: 16 * widget.ffem, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }


  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: AppRouter.navigateToRegister,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade400,
        padding: EdgeInsets.symmetric(vertical: 16 * widget.hem),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12 * widget.fem)),
      ),
      child: Text('Tạo tài khoản mới', style: GoogleFonts.poppins(fontSize: 16 * widget.ffem, fontWeight: FontWeight.w600, color: Colors.white)),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16 * widget.fem),
          child: Text('Hoặc', style: GoogleFonts.poppins(fontSize: 14 * widget.ffem, color: Colors.grey.shade600)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
