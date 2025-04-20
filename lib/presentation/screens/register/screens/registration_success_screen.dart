import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'dart:ui';

class RegistrationSuccessScreen extends StatefulWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  State<RegistrationSuccessScreen> createState() => _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background design with modern gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor.withOpacity(0.8),
                  AppColors.primaryColor,
                  Color(0xFF3D7EFF), // Gradient to blue-ish
                ],
              ),
            ),
          ),

          // Background patterns (subtle circles)
          Positioned(
            top: -screenSize.height * 0.1,
            left: -screenSize.width * 0.2,
            child: Opacity(
              opacity: 0.1,
              child: Container(
                width: screenSize.width * 0.7,
                height: screenSize.width * 0.7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -screenSize.height * 0.05,
            right: -screenSize.width * 0.1,
            child: Opacity(
              opacity: 0.15,
              child: Container(
                width: screenSize.width * 0.6,
                height: screenSize.width * 0.6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Logo or branding
                Opacity(
                  opacity: 0.9,
                  child: Text(
                    'HomeClean',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Success animation
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: _buildSuccessAnimation(),
                              );
                            },
                          ),

                          const SizedBox(height: 32),

                          // Success message
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _opacityAnimation.value,
                                child: Text(
                                  'Đăng Ký Thành Công!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Subtitle
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _opacityAnimation.value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Text(
                                    'Chúc mừng bạn đã trở thành thành viên của HomeClean',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom card with action button
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return AnimatedSlide(
                      duration: const Duration(milliseconds: 800),
                      offset: Offset(0, _opacityAnimation.value - 1),
                      curve: Curves.easeOutBack,
                      child: _buildBottomCard(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
              children: [
                const TextSpan(
                  text: 'Bạn đã sẵn sàng để sử dụng ',
                ),
                TextSpan(
                  text: 'HomeClean',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: ' cho căn nhà của bạn',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildActionButton(context),

        ],
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 140,
          height: 140,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: Icon(
              Icons.check_rounded,
              color: AppColors.primaryColor,
              size: 80,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          AppRouter.navigateToLogin();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Đăng nhập ngay',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}