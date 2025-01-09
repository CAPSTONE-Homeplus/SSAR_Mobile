import 'package:get/get.dart';

import 'presentation/screens/login/login_screen.dart';

class AppRouter {
  static const String routeLogin = '/login';
  static const String routeHome = '/home';

  static List<GetPage> get routes => [
        GetPage(
          name: routeLogin,
          page: () => const LoginScreen(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ];

  static void navigateToHome() {
    Get.toNamed(routeHome);
  }

  static void navigateToLogin() {
    Get.offNamed(routeLogin);
  }
}
