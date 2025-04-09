import 'package:get/get.dart';
import 'package:home_clean/domain/entities/service/service.dart';
import 'package:home_clean/presentation/screens/home/home_screen.dart';
import 'package:home_clean/presentation/screens/message/message_screen.dart';
import 'package:home_clean/presentation/screens/notification/notification.dart';
import 'package:home_clean/presentation/screens/order_confirmation/order_confirmation_screen.dart';
import 'package:home_clean/presentation/screens/order_detail/order_detail_screen.dart';
import 'package:home_clean/presentation/screens/register/register_screen.dart';
import 'package:home_clean/presentation/screens/service_detail/service_detail_screen.dart';
import 'package:home_clean/presentation/screens/start/splash_screen.dart';
import 'package:home_clean/presentation/screens/wallet_management_screen/personal_wallet_screen/personal_wallet_screen.dart';
import 'package:home_clean/presentation/screens/wallet_management_screen/shared_wallet_screen/shared_wallet_screen.dart';

import '../../domain/entities/order/order.dart';
import '../../presentation/laundry_screens/laundry_order_detail_screen/laundry_order_detail_screen.dart';
import '../../presentation/laundry_screens/laundry_service_screen/laundry_service_screen.dart';
import '../../presentation/screens/activity/activity_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/order_list/order_list_screen.dart';
import '../../presentation/screens/order_tracking/order_tracking_screen.dart';
import '../../presentation/screens/rating/rating_screen.dart';
import '../../presentation/screens/service_list_screen/service_list_screen.dart';
import '../../presentation/screens/top_up/top_up_screen.dart';
import '../../presentation/screens/wallet_management_screen/shared_wallet_screen/member_screen/screen/member_screen.dart';
import '../../presentation/screens/wallet_management_screen/shared_wallet_screen/statistics_screen/statistic_screen.dart';
import '../../presentation/widgets/bottom_navigation.dart';

class AppRouter {
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home';
  static const String routeActivity = '/activity';
  static const String routeMessage = '/message';
  static const String routeSetting = '/setting';
  static const String routeSplash = '/splash';
  static const String routeServiceDetails = '/service-details';
  static const String routeServiceDetail = '/service-detail';
  static const String routeTimeCollection = '/time-collection';
  static const String routeOrderConfirmation = '/order-confirmation';
  static const String routePayment = '/payment';
  static const String routeSharedWallet = '/manage-shared-wallet';
  static const String routeMember = '/member';
  static const String routeSpending = '/spending';
  static const String routeNotification = '/notification';
  static const String routePersonalWallet = '/manage-personal-wallet';
  static const String routeOrderTracking = '/order-tracking';
  static const String routeOrderList = '/order-list';
  static const String routeOrderDetail = '/order-detail';
  static const String routeLaundryService = '/laundry-service';
  static const String routeReservationsLaundry = '/reservations-laundry';
  static const String routeLaundryOrderDetail = '/laundry-order-detail';
  static const String routeRating = '/rating-screen';


  static List<GetPage> get routes => [
        GetPage(
          name: routeLogin,
          page: () => const LoginScreen(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeRegister,
          page: () => RegisterScreen(),
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
        GetPage(
          name: routeServiceDetails,
          page: () => ServiceListScreen(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeServiceDetail,
          page: () {
            final Service service = Get.arguments;
            return ServiceDetailScreen(service: service);
          },
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeOrderConfirmation,
          page: () => OrderConfirmationScreen(
            orderDetails: Get.arguments,
          ),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routePayment,
          page: () => TopUpScreen(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeSharedWallet,
          page: () => SharedWalletScreen(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeMember,
          page: () => MembersScreen(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeSpending,
          page: () => SpendingScreen(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeNotification,
          page: () => NotificationScreen(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routePersonalWallet,
          page: () => PersonalWalletScreen(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeOrderTracking,
          page: () => OrderTrackingScreen(orders: Get.arguments),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeOrderDetail,
          page: () => OrdersDetailsScreen(ordersId: Get.arguments),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
            name: routeOrderList,
            page: () => BottomNavigation(child: OrderListScreen()),
            transition: Transition.cupertino,
            transitionDuration: const Duration(milliseconds: 300)
        ),
        GetPage(
          name: routeLaundryService,
          page: () => LaundryServiceScreen(),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
        name: routeLaundryOrderDetail,
        page: () => LaundryOrderDetailScreen(orderId: Get.arguments ?? ""),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: routeRating,
          page: () => RatingReviewPage(orderId: Get.arguments),
          transition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ];

  static void navigateToLogin() {
    Get.toNamed(routeLogin);
  }

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

  static void navigateToServiceDetail(Service service) {
    Get.toNamed(routeServiceDetail, arguments: service);
  }

  static void navigateToServiceDetails() {
    Get.toNamed(routeServiceDetails);
  }

  static void navigateToTimeCollection() {
    Get.toNamed(routeTimeCollection);
  }

  static void navigateToOrderConfirmation(dynamic arguments) {
    Get.toNamed(routeOrderConfirmation, arguments: arguments);
  }

  static void navigateToOrderDetailWithArguments(dynamic arguments) {
    Get.offAndToNamed(routeOrderDetail, arguments: arguments);
  }

  static void navigateToRegister() {
    Get.toNamed(routeRegister);
  }

  static void navigateToPayment() {
    Get.toNamed(routePayment);
  }

  static void navigateToMember() {
    Get.toNamed(routeMember);
  }

  static void navigateToSpending() {
    Get.toNamed(routeSpending);
  }

  static void navigateToNotification() {
    Get.toNamed(routeNotification);
  }

  static void navigateToSharedWallet() {
    Get.toNamed(routeSharedWallet);
  }

  static void navigateToPersonalWallet() {
    Get.toNamed(routePersonalWallet);
  }

  static void navigateToOrderTracking(Orders orders) {
    Get.toNamed(routeOrderTracking, arguments: orders);
  }

  static void navigateToOrderList() {
    Get.toNamed(routeOrderList);
  }

  static void navigateToLaundryService() {
    Get.toNamed(routeLaundryService);
  }

  static void navigateToLaundryItemList(String? serviceTypeId) {
    Get.toNamed(routeReservationsLaundry, arguments: serviceTypeId);
  }

  static void navigateToLaundryOrderDetail(String? orderId) {
    Get.offNamed(routeLaundryOrderDetail, arguments: orderId);
  }
  static void navigateToRatingScreen(String? orderId) {
    Get.offNamed(routeRating, arguments: orderId);
  }

}
