import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';

class RegisterButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final String buildingCode;
  final String houseCode;

  const RegisterButton({
    Key? key,
    required this.formKey,
    required this.fullNameController,
    required this.usernameController,
    required this.passwordController,
    required this.phoneNumberController,
    required this.emailController,
    required this.buildingCode,
    required this.houseCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            if (formKey.currentState?.validate() ?? false) {
              context.read<AuthBloc>().add(
                RegisterAccount(
                  fullName: fullNameController.text,
                  username: usernameController.text,
                  password: passwordController.text,
                  buildingCode: buildingCode,
                  houseCode: houseCode,
                  phoneNumber: phoneNumberController.text,
                  email: emailController.text,
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
}
