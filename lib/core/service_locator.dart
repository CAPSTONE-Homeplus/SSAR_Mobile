import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:home_clean/domain/repositories/building_repository.dart';
import 'package:home_clean/domain/repositories/room_repository.dart';
import 'package:home_clean/domain/usecases/auth/login_usecase.dart';
import 'package:home_clean/domain/usecases/building/get_buildings_usecase.dart';
import 'package:home_clean/domain/usecases/room/get_rooms_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../data/datasource/service_local_data_source.dart';
import '../data/repositories/authentication_repository_impl.dart';
import '../data/repositories/building_repository_impl.dart';
import '../data/repositories/equipment_supply_repository_impl.dart';
import '../data/repositories/extra_service_repository_impl.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../data/repositories/option_repository_impl.dart';
import '../data/repositories/order_repository_impl.dart';
import '../data/repositories/room_repository_impl.dart';
import '../data/repositories/service_activity_repository_impl.dart';
import '../data/repositories/service_category_repository_impl.dart';
import '../data/repositories/service_repository_impl.dart';
import '../data/repositories/sub_activity_repository_impl.dart';
import '../data/repositories/time_slot_repository_impl.dart';
import '../data/repositories/wallet_repository_impl.dart';
import '../domain/repositories/authentication_repository.dart';
import '../domain/repositories/equipment_supply_repository.dart';
import '../domain/repositories/extra_service_repository.dart';
import '../domain/repositories/notification_repository.dart';
import '../../domain/usecases/equipment_supply/get_equipment_supplies_usecase.dart';
import '../../domain/usecases/extra_service/get_extra_service_usecase.dart';
import '../../domain/usecases/option/get_options_usecase.dart';
import '../../domain/usecases/order/create_orders.dart';
import '../../domain/usecases/order/get_order_from_local.dart';
import '../../domain/usecases/order/save_order_to_local.dart';
import '../../domain/usecases/service/clear_selected_service_ids.dart';
import '../../domain/usecases/service/get_selected_service_ids.dart';
import '../../domain/usecases/service/save_selected_service_ids.dart';
import '../../domain/usecases/service_activity/get_service_activities_by_service_usecase.dart';
import '../../domain/usecases/service_category/get_service_by_service_category_usecase.dart';
import '../../domain/usecases/service_category/get_service_categories_usecase.dart';
import '../../domain/usecases/sub_activity/get_sub_activities_usecase.dart';
import '../../domain/usecases/time_slot/get_time_slots_usecase.dart';
import '../../domain/usecases/notification/initialize_notification_usecase.dart';
import '../../domain/usecases/notification/show_notification_usecase.dart';
import '../../presentation/blocs/authentication/authentication_bloc.dart';
import '../../presentation/blocs/equipment/equipment_supply_bloc.dart';
import '../../presentation/blocs/extra_service/extra_service_bloc.dart';
import '../../presentation/blocs/internet/internet_bloc.dart';
import '../../presentation/blocs/notification/notification_bloc.dart';
import '../../presentation/blocs/option/option_bloc.dart';
import '../../presentation/blocs/order/order_bloc.dart';
import '../../presentation/blocs/service/service_bloc.dart';
import '../../presentation/blocs/service_activity/service_activity_bloc.dart';
import '../../presentation/blocs/service_category/service_category_bloc.dart';
import '../../presentation/blocs/sub_activity/sub_activity_bloc.dart';
import '../../presentation/blocs/theme/theme_bloc.dart';
import '../../presentation/blocs/time_slot/time_slot_bloc.dart';
import '../data/datasource/authen_local_datasource.dart';
import '../domain/repositories/option_repository.dart';
import '../domain/repositories/order_repository.dart';
import '../domain/repositories/service_activity_repository.dart';
import '../domain/repositories/service_category_repository.dart';
import '../domain/repositories/service_repository.dart';
import '../domain/repositories/sub_activity_repository.dart';
import '../domain/repositories/time_slot_repository.dart';
import '../domain/repositories/wallet_repository.dart';
import '../domain/usecases/auth/clear_user_from_local_usecase.dart';
import '../domain/usecases/auth/get_user_from_local_usecase.dart';
import '../domain/usecases/auth/save_user_to_local_usecase.dart';
import '../domain/usecases/auth/user_register_usecase.dart';
import '../domain/usecases/wallet/get_wallet_by_user.dart';
import '../presentation/blocs/building/building_bloc.dart';
import '../presentation/blocs/room/room_bloc.dart';
import '../presentation/blocs/wallet/wallet_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  final storage = FlutterSecureStorage();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => storage);

  // LocalDataSources
  sl.registerLazySingleton<ServiceLocalDataSource>(
        () => ServiceLocalDataSource(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthenticationLocalDataSource>(
        () => AuthenticationLocalDataSource(sharedPreferences: sl(), storage: sl()),
  );

  // Repositories (sử dụng LazySingleton vì chúng ta muốn tái sử dụng đối tượng)
  sl.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(localDataSource: sl()));

  sl.registerLazySingleton<ServiceRepository>(
          () => ServiceRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<ServiceCategoryRepository>(
          () => ServiceCategoryRepositoryImpl());
  sl.registerLazySingleton<ServiceActivityRepository>(
          () => ServiceActivityRepositoryImpl());
  sl.registerLazySingleton<OptionRepository>(() => OptionRepositoryImpl());
  sl.registerLazySingleton<SubActivityRepository>(
          () => SubActivityRepositoryImpl());
  sl.registerLazySingleton<ExtraServiceRepository>(
          () => ExtraServiceRepositoryImpl());
  sl.registerLazySingleton<EquipmentSupplyRepository>(
          () => EquipmentSupplyRepositoryImpl());
  sl.registerLazySingleton<TimeSlotRepository>(() => TimeSlotRepositoryImpl());
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl());
  sl.registerLazySingleton<NotificationRepository>(
          () => NotificationRepositoryImpl(sl<FlutterLocalNotificationsPlugin>())
  );
  sl.registerLazySingleton<WalletRepository>(
          () => WalletRepositoryImpl(authenticationRepository: sl()));
  sl.registerLazySingleton<RoomRepository>(() => RoomRepositoryImpl());
  sl.registerLazySingleton<BuildingRepository>(() => BuildingRepositoryImpl());

  // Use Cases
  sl.registerLazySingleton(() => SaveSelectedServiceIds(sl()));
  sl.registerLazySingleton(() => GetSelectedServiceIds(sl()));
  sl.registerLazySingleton(() => ClearSelectedServiceIds(sl()));
  sl.registerLazySingleton(() => GetEquipmentSuppliesUsecase(sl()));
  sl.registerLazySingleton(() => GetExtraServiceUsecase(sl()));
  sl.registerLazySingleton(() => GetOptionsUsecase(sl()));
  sl.registerLazySingleton(() => GetServiceActivitiesByServiceUsecase(sl()));
  sl.registerLazySingleton(() => GetSubActivitiesUsecase(sl()));
  sl.registerLazySingleton(() => GetTimeSlotsUsecase(sl()));
  sl.registerLazySingleton(() => GetServiceByServiceCategoryUsecase(sl()));
  sl.registerLazySingleton(() => GetServiceCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => CreateOrders(sl()));
  sl.registerLazySingleton(() => SaveOrderToLocal (sl()));
  sl.registerLazySingleton(() => GetOrderFromLocal (sl()));
  sl.registerLazySingleton(() => InitializeNotificationUseCase (sl()));
  sl.registerLazySingleton(() => ShowNotificationUseCase (sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetWalletByUser(sl()));
  sl.registerLazySingleton(() => GetRoomsUseCase(sl()));
  sl.registerLazySingleton(() => GetBuildingsUsecase(sl()));
  sl.registerLazySingleton(() => UserRegisterUseCase(sl()));

  // local Use Cases
  sl.registerLazySingleton(() => ClearUserFromLocalUseCase(sl()));
  sl.registerLazySingleton(() => GetUserFromLocalUseCase(sl()));
  sl.registerLazySingleton(() => SaveUserToLocalUseCase(sl()));


  // Blocs (sử dụng Factory vì mỗi bloc sẽ cần một instance mới)
  sl.registerFactory(() => AuthenticationBloc(
      loginUseCase: sl(),
      saveUserToLocalUseCase: sl(),
      getUserFromLocalUseCase: sl(),
      clearUserFromLocalUseCase: sl(),
      userRegisterUseCase: sl()));
  sl.registerFactory(() => InternetBloc());
  sl.registerFactory(() => ThemeBloc(preferences: sl()));
  sl.registerFactory(
        () => ServiceBloc(
      serviceRepository: sl(),
      saveSelectedServiceIds: sl(),
      getSelectedServiceIds: sl(),
      clearSelectedServiceIds: sl(),
    ),
  );
  sl.registerFactory(() => ServiceCategoryBloc(
      getServiceByServiceCategory: sl(), getServiceCategories: sl()));
  sl.registerFactory(
          () => ServiceActivityBloc(getServiceActivitiesByService: sl()));
  sl.registerFactory(() => OptionBloc(getOptionsUsecase: sl()));
  sl.registerFactory(() => SubActivityBloc(getSubActivitiesUsecase: sl()));
  sl.registerFactory(() => ExtraServiceBloc(getExtraServiceUsecase: sl()));
  sl.registerFactory(
          () => EquipmentSupplyBloc(getEquipmentSuppliesUsecase: sl()));
  sl.registerFactory(() => TimeSlotBloc(getTimeSlotsUsecase: sl()));
  sl.registerFactory(() => OrderBloc(createOrder: sl(), saveOrderToLocal: sl(), getOrderFromLocal: sl(), deleteOrderFromLocal: sl()));
  sl.registerFactory(() => NotificationBloc(
      initializeNotificationUseCase: sl(), showNotificationUseCase: sl()));
  sl.registerFactory(() => WalletBloc(getWalletByUser: sl()));
  sl.registerFactory(() => RoomBloc(sl()));
  sl.registerFactory(() => BuildingBloc(buildingRepository: sl()));
}
