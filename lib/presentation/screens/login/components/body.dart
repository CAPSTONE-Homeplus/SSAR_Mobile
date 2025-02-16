import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/colors.dart';
import 'package:home_clean/presentation/screens/login/components/form_login.dart';

import '../../../../core/size_config.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final fem = SizeConfig.fem;
    final hem = SizeConfig.hem;
    final ffem = SizeConfig.ffem;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
        ),
        child: Column(
          children: [
        Expanded(

        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Background design elements
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                left: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              // Main content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * fem),
                child: Column(
                  children: [
                    SizedBox(height: 60 * hem),
                    // Logo animation
                    TweenAnimationBuilder(
                      duration: const Duration(seconds: 1),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            width: 120 * fem,
                            height: 120 * fem,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.home,
                              size: 60 * fem,
                              color: Color(0xFF2193b0),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 40 * hem),
                    // Welcome text with animation
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20 * fem),
                      child: Column(
                        children: [
                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 800),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Text(
                                  'Home Clean',
                                  style: GoogleFonts.poppins(
                                    fontSize: 32 * ffem,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8 * hem),
                          Text(
                            'Quản lý ngôi nhà của bạn một cách dễ dàng',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16 * ffem,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40 * hem),
                    // Login form in a card
                    Container(
                      padding: EdgeInsets.all(24 * fem),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20 * fem),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: FormLogin(fem: fem, hem: hem, ffem: ffem),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
          ],
        ),
      ),
    );
  }
}
