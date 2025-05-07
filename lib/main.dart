import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/core/constant/size_config.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/data/datasource/local/local_data_source.dart';
import 'package:home_clean/data/datasource/local/order_tracking_data_source.dart';
import 'package:home_clean/data/datasource/signalr/order_laundry_remote_data_source.dart';
import 'package:home_clean/data/laundry_repositories/additional_service_repository.dart';
import 'package:home_clean/data/service/notification_service.dart';
import 'package:home_clean/domain/repositories/building_repository.dart';
import 'package:home_clean/domain/repositories/house_repository.dart';
import 'package:home_clean/domain/repositories/laundry_service_type_repository.dart';
import 'package:home_clean/domain/repositories/order_tracking_repository.dart';
import 'package:home_clean/domain/repositories/room_repository.dart';
import 'package:home_clean/domain/repositories/transaction_repository.dart';
import 'package:home_clean/domain/repositories/user_repository.dart';
import 'package:home_clean/presentation/blocs/additional_service/additional_service_bloc.dart';
import 'package:home_clean/presentation/blocs/auth/auth_bloc.dart';
import 'package:home_clean/presentation/blocs/building/building_bloc.dart';
import 'package:home_clean/presentation/blocs/equipment/equipment_supply_bloc.dart';
import 'package:home_clean/presentation/blocs/extra_service/extra_service_bloc.dart';
import 'package:home_clean/presentation/blocs/feedbacks/rating_order_bloc.dart';
import 'package:home_clean/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:home_clean/presentation/blocs/house/house_bloc.dart';
import 'package:home_clean/presentation/blocs/laundry_item_type/laundry_item_type_bloc.dart';
import 'package:home_clean/presentation/blocs/laundry_order/laundry_order_bloc1.dart';
import 'package:home_clean/presentation/blocs/laundry_service_type/laundry_service_type_bloc.dart';
import 'package:home_clean/presentation/blocs/notification/notification_bloc.dart';
import 'package:home_clean/presentation/blocs/option/option_bloc.dart';
import 'package:home_clean/presentation/blocs/order/order_bloc.dart';
import 'package:home_clean/presentation/blocs/order_tracking/order_tracking_bloc.dart';
import 'package:home_clean/presentation/blocs/order_tracking_notification/order_tracking_bloc.dart';
import 'package:home_clean/presentation/blocs/payment_method/payment_method_bloc.dart';
import 'package:home_clean/presentation/blocs/service/service_bloc.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_bloc.dart';
import 'package:home_clean/presentation/blocs/service_category/service_category_bloc.dart';
import 'package:home_clean/presentation/blocs/service_in_house_type/service_price_bloc.dart';
import 'package:home_clean/presentation/blocs/staff/staff_bloc.dart';
import 'package:home_clean/presentation/blocs/sub_activity/sub_activity_bloc.dart';
import 'package:home_clean/presentation/blocs/task/task_bloc.dart';
import 'package:home_clean/presentation/blocs/time_slot/time_slot_bloc.dart';
import 'package:home_clean/presentation/blocs/transaction/transation_bloc.dart';
import 'package:home_clean/presentation/blocs/user/user_bloc.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:home_clean/presentation/laundry_blocs/cancel/cancel_order_bloc.dart';
import 'package:home_clean/presentation/laundry_blocs/order/aundry_order_bloc_v2.dart';
import 'package:home_clean/presentation/laundry_blocs/order/laundry_order_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/dependencies_injection/service_locator.dart';
import 'data/datasource/local/auth_local_datasource.dart';
import 'data/datasource/signalr/app_signalR_service.dart';
import 'data/datasource/signalr/order_tracking_remote_data_source.dart';
import 'data/laundry_repositories/laundry_order_repo.dart';
import 'domain/repositories/authentication_repository.dart';
import 'domain/repositories/equipment_supply_repository.dart';
import 'domain/repositories/extra_service_repository.dart';
import 'domain/repositories/notification_repository.dart';
import 'domain/repositories/option_repository.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/repositories/payment_method_repository.dart';
import 'domain/repositories/service_activity_repository.dart';
import 'domain/repositories/service_category_repository.dart';
import 'domain/repositories/service_repository.dart';
import 'domain/repositories/sub_activity_repository.dart';
import 'domain/repositories/time_slot_repository.dart';
import 'domain/repositories/wallet_repository.dart';
import 'domain/use_cases/local/cear_all_data_use_case.dart';
import 'presentation/blocs/internet/internet_bloc.dart';
import 'presentation/blocs/room/room_bloc.dart';
import 'presentation/blocs/theme/theme_bloc.dart';

final sl = GetIt.instance;
final navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp();
  await setupServiceLocator();
  await _requestNotificationPermission();
  await NotificationService.init();
  await initializeDateFormatting('vi_VN', null);
  await initSignalR();
  runApp(HomeClean(preferences: sl<SharedPreferences>()));
}

Future<void> _requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
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

class HomeClean extends StatelessWidget {
  final SharedPreferences preferences;

  const HomeClean({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // MultiRepositoryProvider để cung cấp nhiều repository cho ứng dụng
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => sl<AuthRepository>()),
        RepositoryProvider<UserRepository>(create: (_) => sl<UserRepository>()),
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
        RepositoryProvider(create: (_) => sl<WalletRepository>()),
        RepositoryProvider(create: (_) => sl<RoomRepository>()),
        RepositoryProvider(create: (_) => sl<BuildingRepository>()),
        RepositoryProvider(create: (_) => sl<TransactionRepository>()),
        RepositoryProvider(create: (_) => sl<PaymentMethodRepository>()),
        RepositoryProvider(create: (_) => sl<HouseRepository>()),
        RepositoryProvider(create: (_) => sl<UserRepository>()),
        RepositoryProvider(create: (_) => sl<NotificationRepository>()),
        RepositoryProvider(create: (_) => sl<OrderTrackingRepository>()),
        RepositoryProvider(create: (_) => sl<LaundryServiceTypeRepository>()),
        RepositoryProvider(create: (_) => sl<AdditionalServiceRepository>()),
        RepositoryProvider(create: (_) => sl<LaundryOrderRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => InternetBloc()),
          BlocProvider(
              create: (context) => ThemeBloc(preferences: preferences)),
          BlocProvider(
              create: (context) => AuthBloc(
                  loginUseCase: sl(),
                  userRegisterUseCase: sl(),
                  getUserFromLocalUseCase: sl(),
                  refreshTokenUseCase: sl())),
          BlocProvider(
              create: (context) => ServiceBloc(
                    getServicesUseCase: sl(),
                    serviceRepository: sl(),
                  )),
          BlocProvider(
              create: (context) => ServiceCategoryBloc(
                  getServiceByServiceCategory: sl(),
                  getServiceCategories: sl())),
          BlocProvider(
              create: (context) =>
                  ServiceActivityBloc(getServiceActivitiesByService: sl())),
          BlocProvider(
              create: (context) => OptionBloc(getOptionsUseCase: sl())),
          BlocProvider(
              create: (context) =>
                  SubActivityBloc(getSubActivitiesUsecase: sl())),
          BlocProvider(
              create: (context) =>
                  ExtraServiceBloc(getExtraServiceUseCase: sl())),
          BlocProvider(
              create: (context) =>
                  EquipmentSupplyBloc(getEquipmentSuppliesUseCase: sl())),
          BlocProvider(
              create: (context) => TimeSlotBloc(getTimeSlotsUsecase: sl())),
          BlocProvider(
              create: (context) => OrderBloc(
                  createOrderUseCase: sl(),
                  getOrderByUserUseCase: sl(),
                  getOrderUseCase: sl(),
                  cancelOrderUseCase: sl(),
                  orderRepository: sl())),
          BlocProvider(
              create: (context) => WalletBloc(
                  getWalletByUser: sl(),
                  createWalletUseCase: sl(),
                  walletRepository: sl(),
                  changeOwnerUseCase: sl(),
                  deleteUserUseCase: sl(),
                  getContributionStatisticUseCase: sl())),
          BlocProvider(create: (context) => RoomBloc(sl())),
          BlocProvider(
              create: (context) => BuildingBloc(
                  getBuildingUseCase: sl(), getBuildingsUseCase: sl())),
          BlocProvider(create: (context) => TransactionBloc(sl(), sl(), sl(), sl())),
          BlocProvider(
              create: (context) => HouseBloc(
                  getHouseByBuildingUseCase: sl(), getHouseByUseCase: sl())),
          BlocProvider(create: (context) => PaymentMethodBloc(sl())),
          BlocProvider(create: (context) => UserBloc(sl(), sl(), sl(), sl())),
          BlocProvider(
              create: (context) => NotificationBloc(
                  getNotificationsUseCase: sl(),
                  connectToHubUseCase: sl(),
                  disconnectFromHubUseCase: sl(),
                  listenForNotificationsUseCase: sl(),
                  flutterLocalNotificationsPlugin:
                      flutterLocalNotificationsPlugin)),
          BlocProvider(
              create: (context) => PersonalWalletBloc(getWalletByUser: sl())),
          BlocProvider(
              create: (context) => SharedWalletBloc(getWalletByUser: sl())),
          BlocProvider(
              create: (context) => OrderTrackingBloc(
                    connectToHub: sl(),
                    disconnectFromHub: sl(),
                    getLocalTrackings: sl(),
                    getTrackingById: sl(),
                    streamTracking: sl(),
                  )),
          BlocProvider(create: (context) => LaundryServiceTypeBloc(sl(), sl())),
          BlocProvider(
              create: (context) => LaundryOrderBlocV2(orderRepository: sl())),
          BlocProvider(create: (context) => LaundryItemTypeBloc(sl())),
          BlocProvider(
              create: (context) => AdditionalServiceBloc(repository: sl())),
          BlocProvider(create: (context) => LaundryOrderBloc(sl())),
          BlocProvider(
              create: (context) => ChangeOwnerBloc(walletRepository: sl())),
          BlocProvider(
              create: (context) => DissolutionBloc(walletRepository: sl())),
          BlocProvider(create: (context) => StaffBloc(orderRepository: sl())),
          BlocProvider(
              create: (context) => RatingOrderBloc(orderRepository: sl())),
          BlocProvider(
              create: (context) => ServicePriceBloc(serviceRepository: sl())),
          BlocProvider(
              create: (context) => TransferBloc(
                  walletRepository: sl(),)),
          BlocProvider<LaundryOrderBloc1>(
            create: (context) => LaundryOrderBloc1(
              sl<OrderLaundryRemoteDataSource>(),
            ),
          ),
          BlocProvider(
            create: (context) => TaskBloc(
              taskRepository: sl(),
            ),
          ),
          BlocProvider(
            create: (context) => ForgotPasswordBloc(
              authRepository: sl<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CancelOrderBloc(
              repository: sl<LaundryOrderRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => OrderTrackingBloc1(
              remoteDataSource: sl<OrderTrackingRemoteDataSource>(),
              localDataSource: sl<OrderTrackingLocalDataSource>(),
            ),
          ),
        ],
        child:GetMaterialApp(
          color: AppColors.primaryColor,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Home Clean',
          theme: ThemeData(
            primaryColor: AppColors.primaryColor,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          getPages: AppRouter.routes,
          initialRoute: AppRouter.routeSplash,
        ),
      ),
    );
  }
}
