import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/data/repositories/authentication_repository_impl.dart';
import 'package:home_clean/domain/entities/refresh_token/refresh_token_model.dart';
import 'package:home_clean/domain/repositories/authentication_repository.dart';
import 'package:home_clean/presentation/screens/login/login_screen.dart';

import '../../../core/dependencies_injection/service_locator.dart';
import '../../../core/request/request.dart';
import '../../../data/datasource/local/auth_local_datasource.dart';
import '../../../data/datasource/local/order_tracking_data_source.dart';
import '../../../data/datasource/signalr/app_signalR_service.dart';
import '../../../domain/use_cases/local/cear_all_data_use_case.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/show_dialog.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _controller.forward();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    // Kiểm tra kết nối mạng
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showCustomDialog(
        context: context,
        message: "Không có kết nối Internet. Vui lòng kiểm tra mạng của bạn.",
        type: DialogType.error,
        onConfirm: () {},
      );
      return;
    }

    final authLocalDataSource = AuthLocalDataSource();
    final accessToken = await authLocalDataSource.getAccessTokenFromStorage();
    print('📤 Load accessToken: $accessToken');

    if (accessToken == null || accessToken.isEmpty) {
      await clearLocalStorageAndLogout();
      navigateToLogin();
      return;
    }

    setAuthorizationHeader(accessToken);
    final authRepository = sl<AuthRepository>();
    final isValidToken = await authRepository.isValidToken();

    if (isValidToken) {
      initSignalR();
      navigateToHome();
    } else {
      showCustomDialog(
        context: context,
        message: "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.",
        type: DialogType.error,
        onConfirm: () async {
          await _clearAndLogout();
        },
      );
    }
  }



  void setAuthorizationHeader(String accessToken) {
    final authHeader = 'Bearer $accessToken';
    vinWalletRequest.options.headers['Authorization'] = authHeader;
    homeCleanRequest.options.headers['Authorization'] = authHeader;
    vinLaundryRequest.options.headers['Authorization'] = authHeader;
  }

  voidRemoveAuthHeader() {
    vinWalletRequest.options.headers.remove('Authorization');
    homeCleanRequest.options.headers.remove('Authorization');
    vinLaundryRequest.options.headers.remove('Authorization');
  }

  Future<void> _clearAndLogout() async {
    await clearLocalStorageAndLogout();
    voidRemoveAuthHeader();
    navigateToLogin();
  }

  Future<void> initSignalR() async {
    try {
      await AppSignalrService.init(
        authLocalDataSource: sl<AuthLocalDataSource>(),
      );
    } catch (e) {
      print('❌ Lỗi kết nối SignalR: $e');
      sl<ClearAllDataUseCase>().call();
      AppRouter.navigateToLogin();
    }
  }

  void navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BottomNavigation(child: HomeScreen()),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var fadeAnimation =
              Tween<double>(begin: 0.0, end: 1.0).animate(animation);
          return FadeTransition(opacity: fadeAnimation, child: child);
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var fadeAnimation =
              Tween<double>(begin: 0.0, end: 1.0).animate(animation);
          return FadeTransition(opacity: fadeAnimation, child: child);
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1CAF7D),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1CAF7D),
                  Color(0xFF15916A),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.cleaning_services,
                          size: 60,
                          color: Color(0xFF1CAF7D),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // App Name
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Home Clean',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Tagline
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Your Home, Our Care',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),

                  // Loading indicator
                  SizedBox(height: 48),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
