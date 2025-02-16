import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/app_router.dart';
import 'package:home_clean/data/repositories/order/order_repository.dart';
import 'package:home_clean/presentation/blocs/equipment/equipment_supply_bloc.dart';
import 'package:home_clean/presentation/blocs/extra_service/extra_service_bloc.dart';
import 'package:home_clean/presentation/blocs/notification/notification_bloc.dart';
import 'package:home_clean/presentation/blocs/option/option_bloc.dart';
import 'package:home_clean/presentation/blocs/order/order_bloc.dart';
import 'package:home_clean/presentation/blocs/service/service_bloc.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_bloc.dart';
import 'package:home_clean/presentation/blocs/service_category/service_category_bloc.dart';
import 'package:home_clean/presentation/blocs/sub_activity/sub_activity_bloc.dart';
import 'package:home_clean/presentation/blocs/time_slot/time_slot_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/service_locator.dart';
import 'data/repositories/auth/authentication_repository.dart';
import 'data/repositories/equipment_supply/equipment_supply_repository.dart';
import 'data/repositories/extra_service/extra_service_repository.dart';
import 'data/repositories/notification/notification_repository.dart';
import 'data/repositories/option/option_repository.dart';
import 'data/repositories/service/service_repository.dart';
import 'data/repositories/service_activity/service_activity_repository.dart';
import 'data/repositories/service_category/service_category_repository.dart';
import 'data/repositories/sub_activity/sub_activity_repository.dart';
import 'data/repositories/time_slot/time_slot_repository.dart';
import 'domain/usecases/notification/initialize_notification_usecase.dart';
import 'presentation/blocs/authentication/authentication_bloc.dart';
import 'presentation/blocs/internet/internet_bloc.dart';
import 'presentation/blocs/theme/theme_bloc.dart';

final sl = GetIt.instance;
final navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
late InitializeNotificationUseCase _initializeNotificationUseCase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupServiceLocator();
  _initializeNotificationUseCase = InitializeNotificationUseCase(sl());
  await _initializeNotificationUseCase.call();
  await initializeDateFormatting('vi_VN', null);
  runApp(HomeClean(preferences: sl<SharedPreferences>()));
}


class HomeClean extends StatelessWidget {
  final SharedPreferences preferences;

  const HomeClean({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    // MultiRepositoryProvider để cung cấp nhiều repository cho ứng dụng
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
            create: (_) => sl<AuthenticationRepository>()),
        RepositoryProvider<ServiceRepository>(
            create: (_) => sl<ServiceRepository>()),
        RepositoryProvider<ServiceCategoryRepository>(
            create: (_) => sl<ServiceCategoryRepository>()),
        RepositoryProvider<ServiceActivityRepository>(
            create: (_) => sl<ServiceActivityRepository>()),
        RepositoryProvider<OptionRepository>(
            create: (_) => sl<OptionRepository>()),
        RepositoryProvider<SubActivityRepository>(
            create: (_) => sl<SubActivityRepository>()),
        RepositoryProvider<ExtraServiceRepository>(
            create: (_) => sl<ExtraServiceRepository>()),
        RepositoryProvider<EquipmentSupplyRepository>(
            create: (_) => sl<EquipmentSupplyRepository>()),
        RepositoryProvider<TimeSlotRepository>(
            create: (_) => sl<TimeSlotRepository>()),
        RepositoryProvider<OrderRepository>(
            create: (_) => sl<OrderRepository>()),
        RepositoryProvider(create: (_) => sl<NotificationRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => InternetBloc()),
          BlocProvider(
              create: (context) => ThemeBloc(preferences: preferences)),
          BlocProvider(
              create: (context) =>
                  AuthenticationBloc(loginUseCase: sl(), saveUserToLocalUseCase: sl(),
                      getUserFromLocalUseCase: sl(), clearUserFromLocalUseCase: sl())),
          BlocProvider(
              create: (context) => ServiceBloc(
                  serviceRepository: sl(),
                  saveSelectedServiceIds: sl(),
                  getSelectedServiceIds: sl(),
                  clearSelectedServiceIds: sl())),
          BlocProvider(
              create: (context) => ServiceCategoryBloc(
                  getServiceByServiceCategory: sl(),
                  getServiceCategories: sl())),
          BlocProvider(
              create: (context) =>
                  ServiceActivityBloc(getServiceActivitiesByService: sl())),
          BlocProvider(
              create: (context) => OptionBloc(getOptionsUsecase: sl())),
          BlocProvider(
              create: (context) =>
                  SubActivityBloc(getSubActivitiesUsecase: sl())),
          BlocProvider(
              create: (context) =>
                  ExtraServiceBloc(getExtraServiceUsecase: sl())),
          BlocProvider(
              create: (context) =>
                  EquipmentSupplyBloc(getEquipmentSuppliesUsecase: sl())),
          BlocProvider(
              create: (context) => TimeSlotBloc(getTimeSlotsUsecase: sl())),
          BlocProvider(create: (context) => OrderBloc(createOrder: sl(), saveOrderToLocal: sl(), getOrderFromLocal: sl(), deleteOrderFromLocal: sl())),
          BlocProvider(
              create: (context) => NotificationBloc(
                  initializeNotificationUseCase: sl(),
                  showNotificationUseCase: sl())),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            ThemeData themeData = ThemeData.light();

            if (state is ThemeInitial) {
              themeData = state.themeData;
            }

            return GetMaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Home Clean',
              theme: themeData.copyWith(
                textTheme: GoogleFonts.notoSansTextTheme(themeData.textTheme),
              ),
              getPages: AppRouter.routes,
              initialRoute: AppRouter.routeLogin,
            );
          },
        ),
      ),
    );
  }
}
