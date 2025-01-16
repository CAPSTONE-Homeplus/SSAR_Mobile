import 'package:get/get.dart';
import 'package:home_clean/presentation/screens/home/home_screen.dart';
import 'package:home_clean/presentation/screens/message/message_screen.dart';
import 'package:home_clean/presentation/screens/start/splash_screen.dart';

import 'presentation/screens/activity/activity_screen.dart';
import 'presentation/screens/login/login_screen.dart';
import 'presentation/widgets/bottom_navigation.dart';

class AppRouter {
  static const String routeLogin = '/login';
  static const String routeHome = '/home';
  static const String routeActivity = '/activity';
  static const String routeMessage = '/message';
  static const String routeSetting = '/setting';
  static const String routeSplash = '/splash';

  static List<GetPage> get routes => [
        GetPage(
          name: routeLogin,
          page: () => const LoginScreen(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeHome,
          page: () => BottomNavigation(child: HomeScreen()),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeActivity,
          page: () => BottomNavigation(child: ActivityScreen()),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeMessage,
          page: () => BottomNavigation(child: MessageScreen()),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeSetting,
          page: () => BottomNavigation(child: MessageScreen()),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeSplash,
          page: () => SplashScreen(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ];

  static void navigateToHome() {
    Get.toNamed(routeHome);
  }

  static void navigateToLoginAndRemoveAll() {
    Get.offAllNamed(routeLogin);
  }

  static void navigateToActivity() {
    Get.toNamed(routeActivity);
  }

  static void navigateToMessage() {
    Get.toNamed(routeMessage);
  }

  static void navigateToSetting() {
    Get.toNamed(routeSetting);
  }

  static void navigateToSplash() {
    Get.offAllNamed(routeSplash);
  }
}
