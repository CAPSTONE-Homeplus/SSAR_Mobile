import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/presentation/blocs/user/user_state.dart';
import 'package:home_clean/presentation/widgets/show_dialog.dart';

import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_event.dart';

class PersonalInfoScreen extends StatefulWidget {
  final Function(String fullName, String phoneNumber, String email) onNext;

  const PersonalInfoScreen({super.key, required this.onNext});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final Color _primaryColor = const Color(0xFF1CAF7D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông tin cá nhân',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is CheckUserInfoSuccess) {
            widget.onNext(
              _fullNameController.text,
              _phoneNumberController.text,
              _emailController.text,
            );
          } else if (state is UserError) {
            showCustomDialog(
              context: context,
              message: state.message,
              type: DialogType.error,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Bước 1/3: Thông tin cá nhân',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Họ và tên',
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
                  controller: _phoneNumberController,
                  label: 'Số điện thoại',
                  hint: 'Nhập số điện thoại của bạn',
                  icon: Icons.phone_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
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
                const Spacer(),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    final bool isLoading = state is UserLoading;

                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                        if (_formKey.currentState!.validate()) {
                          context.read<UserBloc>().add(
                            CheckUserInfoEvent(
                              phoneNumber: _phoneNumberController.text,
                              email: _emailController.text),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Tiếp tục',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
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
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: GoogleFonts.poppins(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: _primaryColor),
            suffixIcon: isPassword && onTogglePassword != null
                ? IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
              onPressed: onTogglePassword,
            )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}