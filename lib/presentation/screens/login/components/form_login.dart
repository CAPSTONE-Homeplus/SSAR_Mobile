import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/app_router.dart';
import 'package:home_clean/core/size_config.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/internet/internet_bloc.dart';
import '../../../widgets/notification.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({
    super.key,
    required this.fem,
    required this.hem,
    required this.ffem,
  });

  final double fem;
  final double hem;
  final double ffem;

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  final Color primaryColor = const Color(0xFF1CAF7D);

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;
    var loginWidget = (switch (authState) {
      AuthenticationInitial() => _buildLoginForm(),
      AuthenticationFailed(error: final error) => _buildLoginForm(error: error),
      AuthenticationSuccess() => _buildLoginForm(),
      AuthenticationLoading() => _buildLoginForm(),
      AuthenticationState() => throw UnimplementedError(),
    });

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          loginWidget,
          SizedBox(height: 25 * widget.hem),
          _buildLoginButton(context),
          SizedBox(height: 16 * widget.hem),
          _buildDivider(),
          SizedBox(height: 8 * widget.hem),
          _buildRegisterButton(),
        ],
      ),
    );
  }

  Widget _buildLoginForm({String? error}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: userNameController,
          hint: 'Username or Email',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter username';
            }
            return null;
          },
        ),
        SizedBox(height: 16 * widget.hem),
        _buildTextField(
          controller: passwordController,
          hint: 'Password',
          icon: Icons.lock_outline,
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            }
            return null;
          },
        ),
        SizedBox(height: 8 * widget.hem),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Handle forgot password
            },
            child: Text(
              'Forgot Password?',
              style: GoogleFonts.poppins(
                fontSize: 14 * widget.ffem,
                color: primaryColor,
              ),
            ),
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
        hintStyle: GoogleFonts.poppins(
          fontSize: 15 * widget.ffem,
          color: Colors.grey.shade400,
        ),
        prefixIcon: Icon(icon, color: primaryColor),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * widget.fem),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * widget.fem),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * widget.fem),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSuccess) {
          AppRouter.navigateToHome();
        } else if (state is AuthenticationFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: ElevatedButton(
        onPressed: () {
          if (context.read<InternetBloc>().state is Connected) {
            if (_formKey.currentState!.validate()) {
              context.read<AuthenticationBloc>().add(
                LoginAccount(
                  username: userNameController.text.trim(),
                  password: passwordController.text,
                ),
              );
            }
          } else {
            NotificationApp.show(
              context,
              'Không có kết nối Internet!',
              backgroundColor: Colors.red.shade400,
              icon: Icons.error,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16 * widget.hem),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12 * widget.fem),
          ),
        ),
        child: Text(
          'Đăng nhập',
          style: GoogleFonts.poppins(
            fontSize: 16 * widget.ffem,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () {
          AppRouter.navigateToRegister();
        },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade400,
        padding: EdgeInsets.symmetric(vertical: 16 * widget.hem),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12 * widget.fem),
        ),
      ),
      child: Text(
        'Tạo tài khoản mới',
        style: GoogleFonts.poppins(
          fontSize: 16 * widget.ffem,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16 * widget.fem),
          child: Text(
            'Hoặc',
            style: GoogleFonts.poppins(
              fontSize: 14 * widget.ffem,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}