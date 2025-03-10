import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:home_clean/data/datasource/local/activity_status_local_data_source.dart';
import 'package:home_clean/data/datasource/signalr/activity_status_remote_data_source.dart';
import 'package:home_clean/data/datasource/signalr/wallet_remote_data_source.dart';
import 'package:home_clean/domain/repositories/activity_status_repository.dart';
import 'package:home_clean/domain/repositories/building_repository.dart';
import 'package:home_clean/domain/repositories/house_repository.dart';
import 'package:home_clean/domain/repositories/payment_method_repository.dart';
import 'package:home_clean/domain/repositories/room_repository.dart';
import 'package:home_clean/domain/repositories/transaction_repository.dart';
import 'package:home_clean/domain/repositories/user_repository.dart';
import 'package:home_clean/domain/use_cases/auth/login_usecase.dart';
import 'package:home_clean/domain/use_cases/building/get_buildings_use_case.dart';
import 'package:home_clean/domain/use_cases/extra_service/get_extra_service_use_case.dart';
import 'package:home_clean/domain/use_cases/order/create_orders_use_case.dart';
import 'package:home_clean/domain/use_cases/room/get_rooms_usecase.dart';
import 'package:home_clean/domain/use_cases/service/get_services_use_case.dart';
import 'package:home_clean/domain/use_cases/transaction/save_transaction_use_case.dart';
import 'package:home_clean/domain/use_cases/user/get_user_by_phone_number_use_case.dart';
import 'package:home_clean/domain/use_cases/user/get_users_by_shared_wallet_use_case.dart';
import 'package:home_clean/domain/use_cases/wallet/delete_user_wallet_use_case.dart';
import 'package:home_clean/domain/use_cases/wallet/invite_member_wallet_use_case.dart';
import 'package:home_clean/presentation/blocs/house/house_bloc.dart';
import 'package:home_clean/presentation/blocs/user/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../data/datasource/local/service_local_data_source.dart';
import '../../data/datasource/local/local_data_source.dart';
import '../../data/datasource/local/transaction_local_data_source.dart';
import '../../data/datasource/local/user_local_datasource.dart';
import '../../data/datasource/local/wallet_local_data_source.dart';
import '../../data/repositories/activity_status_repository_impl.dart';
import '../../data/repositories/authentication_repository_impl.dart';
import '../../data/repositories/building_repository_impl.dart';
import '../../data/repositories/equipment_supply_repository_impl.dart';
import '../../data/repositories/extra_service_repository_impl.dart';
import '../../data/repositories/house_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/repositories/option_repository_impl.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/repositories/payment_method_repository_impl.dart';
import '../../data/repositories/room_repository_impl.dart';
import '../../data/repositories/service_activity_repository_impl.dart';
import '../../data/repositories/service_category_repository_impl.dart';
import '../../data/repositories/service_repository_impl.dart';
import '../../data/repositories/sub_activity_repository_impl.dart';
import '../../data/repositories/time_slot_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/repositories/equipment_supply_repository.dart';
import '../../domain/repositories/extra_service_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../../domain/use_cases/equipment_supply/get_equipment_supplies_use_case.dart';
import '../../../domain/use_cases/service/clear_selected_service_ids.dart';
import '../../../domain/use_cases/service/get_selected_service_ids.dart';
import '../../../domain/use_cases/service/save_selected_service_ids.dart';
import '../../../domain/use_cases/service_activity/get_service_activities_by_service_usecase.dart';
import '../../../domain/use_cases/service_category/get_service_by_service_category_usecase.dart';
import '../../../domain/use_cases/service_category/get_service_categories_usecase.dart';
import '../../../domain/use_cases/sub_activity/get_sub_activities_usecase.dart';
import '../../../domain/use_cases/time_slot/get_time_slots_usecase.dart';
import '../../../presentation/blocs/equipment/equipment_supply_bloc.dart';
import '../../../presentation/blocs/extra_service/extra_service_bloc.dart';
import '../../../presentation/blocs/internet/internet_bloc.dart';
import '../../../presentation/blocs/notification/notification_bloc.dart';
import '../../../presentation/blocs/option/option_bloc.dart';
import '../../../presentation/blocs/order/order_bloc.dart';
import '../../../presentation/blocs/service/service_bloc.dart';
import '../../../presentation/blocs/service_activity/service_activity_bloc.dart';
import '../../../presentation/blocs/service_category/service_category_bloc.dart';
import '../../../presentation/blocs/sub_activity/sub_activity_bloc.dart';
import '../../../presentation/blocs/theme/theme_bloc.dart';
import '../../../presentation/blocs/time_slot/time_slot_bloc.dart';
import '../../data/datasource/local/auth_local_datasource.dart';
import '../../domain/repositories/option_repository.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/repositories/service_activity_repository.dart';
import '../../domain/repositories/service_category_repository.dart';
import '../../domain/repositories/service_repository.dart';
import '../../domain/repositories/sub_activity_repository.dart';
import '../../domain/repositories/time_slot_repository.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/use_cases/auth/get_user_from_local_usecase.dart';
import '../../domain/use_cases/auth/user_register_usecase.dart';
import '../../domain/use_cases/building/get_building_use_case.dart';
import '../../domain/use_cases/house/get_house_by_building_use_case.dart';
import '../../domain/use_cases/house/get_house_use_case.dart';
import '../../domain/use_cases/notification/connect_to_notification_hub_use_case.dart';
import '../../domain/use_cases/notification/delete_notification_use_case.dart';
import '../../domain/use_cases/notification/disconnect_from_notification_hub_use_case.dart';
import '../../domain/use_cases/notification/get_notifications_use_case.dart';
import '../../domain/use_cases/notification/listen_for_notifications_use_case.dart';
import '../../domain/use_cases/notification/mark_notification_as_read_use_case.dart';
import '../../domain/use_cases/option/get_options_use_case.dart';
import '../../domain/use_cases/payment_method/get_payment_methods_use_case.dart';
import '../../domain/use_cases/transaction/get_transaction_by_user.dart';
import '../../domain/use_cases/transaction/get_transaction_by_wallet_use_case.dart';
import '../../domain/use_cases/wallet/change_owner_use_case.dart';
import '../../domain/use_cases/wallet/create_wallet_use_case.dart';
import '../../domain/use_cases/wallet/get_wallet_by_user.dart';
import '../../presentation/blocs/activity_status_bloc/activity_status_bloc.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/building/building_bloc.dart';
import '../../presentation/blocs/payment_method/payment_method_bloc.dart';
import '../../presentation/blocs/room/room_bloc.dart';
import '../../presentation/blocs/transaction/transation_bloc.dart';
import '../../presentation/blocs/wallet/wallet_bloc.dart';

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
        () => ServiceLocalDataSource(),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSource(),
  );

  sl.registerLazySingleton<UserLocalDatasource>(
        () => UserLocalDatasource(),
  );


  sl.registerLazySingleton<TransactionLocalDataSource>(
        () => TransactionLocalDataSource(),
  );
  sl.registerLazySingleton<WalletLocalDataSource>(
        () => WalletLocalDataSource(),
  );
  sl.registerLazySingleton<ActivityStatusLocalDataSource>(
        () => ActivityStatusLocalDataSource(),
  );

  // signalr
  sl.registerLazySingleton<ActivityStatusRemoteDataSource>(
        () => ActivityStatusRemoteDataSource(authLocalDataSource: sl()),
  );
  sl.registerLazySingleton<WalletRemoteDataSource>(
        () => WalletRemoteDataSource(authLocalDataSource: sl()),
  );

  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSource(
    authLocalDataSource: sl(),
    extraServiceLocalDataSource: sl(),
    optionLocalDataSource: sl(),
    serviceLocalDataSource: sl(),
    transactionLocalDataSource: sl(),
    userLocalDatasource: sl(),
    walletLocalDataSource: sl(),
  ));

  // Repositories (sử dụng LazySingleton vì chúng ta muốn tái sử dụng đối tượng)
  sl.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(authLocalDataSource: sl(), userLocalDatasource: sl(),
              userRepository: sl()));
  sl.registerLazySingleton<UserRepository>(
          () => UserRepositoryImpl(userLocalDatasource: sl()));
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
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl( userLocalDatasource: sl()));
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(
    localDataSource: sl(),
    remoteDataSource: sl(),
  ));


  sl.registerLazySingleton<WalletRepository>(
          () => WalletRepositoryImpl(authLocalDataSource: sl(), userLocalDatasource: sl(), localDataSource: sl()));
  sl.registerLazySingleton<RoomRepository>(() => RoomRepositoryImpl());
  sl.registerLazySingleton<BuildingRepository>(() => BuildingRepositoryImpl());
  sl.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(
    authLocalDataSource: sl(),
    transactionLocalDataSource: sl(),
  ));
  sl.registerLazySingleton<PaymentMethodRepository>(() => PaymentMethodRepositoryImpl());
  sl.registerLazySingleton<HouseRepository>(() => HouseRepositoryImpl());
  sl.registerLazySingleton<ActivityStatusRepository>(() => ActivityStatusRepositoryImpl(
    localDataSource: sl(),
    remoteDataSource: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => SaveSelectedServiceIds(sl()));
  sl.registerLazySingleton(() => GetSelectedServiceIds(sl()));
  sl.registerLazySingleton(() => ClearSelectedServiceIds(sl()));
  sl.registerLazySingleton(() => GetEquipmentSuppliesUseCase(sl()));
  sl.registerLazySingleton(() => GetExtraServiceUseCase(sl()));
  sl.registerLazySingleton(() => GetOptionsUseCase(sl()));
  sl.registerLazySingleton(() => GetServiceActivitiesByServiceUsecase(sl()));
  sl.registerLazySingleton(() => GetSubActivitiesUsecase(sl()));
  sl.registerLazySingleton(() => GetTimeSlotsUsecase(sl()));
  sl.registerLazySingleton(() => GetServiceByServiceCategoryUsecase(sl()));
  sl.registerLazySingleton(() => GetServiceCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetWalletByUserUseCase(sl()));
  sl.registerLazySingleton(() => GetRoomsUseCase(sl()));
  sl.registerLazySingleton(() => GetBuildingsUseCase(sl()));
  sl.registerLazySingleton(() => UserRegisterUseCase(sl()));
  sl.registerLazySingleton(() => SaveTransactionUseCase(sl()));
  sl.registerLazySingleton(() => GetPaymentMethodsUseCase(sl()));
  sl.registerLazySingleton(() => GetHouseByBuildingUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionByUserUseCase(sl()));
  sl.registerLazySingleton(() => GetHouseUseCase(sl()));
  sl.registerLazySingleton(() => GetBuildingUseCase(sl()));
  sl.registerLazySingleton(() => CreateOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetServicesUseCase(sl()));
  sl.registerLazySingleton(() => CreateWalletUseCase(sl()));
  sl.registerLazySingleton(() => GetUsersBySharedWalletUseCase(sl()));
  sl.registerLazySingleton(() => InviteMemberWalletUseCase(sl()));
  sl.registerLazySingleton(() => ChangeOwnerUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserWalletUseCase(sl()));
  sl.registerLazySingleton(() => GetUserByPhoneNumberUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionByWalletUseCase(sl()));
  sl.registerLazySingleton(()=> GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(()=> MarkNotificationAsReadUseCase(sl()));
  sl.registerLazySingleton(() => DeleteNotificationUseCase(sl()));
  sl.registerLazySingleton(() => ConnectToNotificationHubUseCase(sl()));
  sl.registerLazySingleton(() => DisconnectFromNotificationHubUseCase(sl()));
  sl.registerLazySingleton(() => ListenForNotificationsUseCase(sl()));


  // local Use Cases
  sl.registerLazySingleton(() => GetUserFromLocalUseCase(sl()));
  // sl.registerLazySingleton(() => SaveUserToLocalUseCase(sl()));


  // Blocs (sử dụng Factory vì mỗi bloc sẽ cần một instance mới)
  sl.registerSingleton(() => AuthBloc(
      loginUseCase: sl(),
      userRegisterUseCase: sl(),
      getUserFromLocalUseCase: sl()));
  sl.registerFactory(() => InternetBloc());
  sl.registerFactory(() => ThemeBloc(preferences: sl()));
  sl.registerFactory(
        () => ServiceBloc(
      getServicesUseCase: sl(),
      saveSelectedServiceIds: sl(),
      getSelectedServiceIds: sl(),
      clearSelectedServiceIds: sl(),
    ),
  );
  sl.registerFactory(() => ServiceCategoryBloc(
      getServiceByServiceCategory: sl(), getServiceCategories: sl()));
  sl.registerFactory(
          () => ServiceActivityBloc(getServiceActivitiesByService: sl()));
  sl.registerFactory(() => OptionBloc(getOptionsUseCase: sl()));
  sl.registerFactory(() => SubActivityBloc(getSubActivitiesUsecase: sl()));
  sl.registerFactory(() => ExtraServiceBloc(getExtraServiceUseCase: sl()));
  sl.registerFactory(
          () => EquipmentSupplyBloc(getEquipmentSuppliesUseCase: sl()));
  sl.registerFactory(() => TimeSlotBloc(getTimeSlotsUsecase: sl()));
  sl.registerFactory(() => OrderBloc(createOrderUseCase: sl()));
  sl.registerFactory(
        () => NotificationBloc(
      getNotificationsUseCase: sl(),
      markAsReadUseCase: sl(),
      deleteNotificationUseCase: sl(),
      connectToHubUseCase: sl(),
      disconnectFromHubUseCase: sl(),
      listenForNotificationsUseCase: sl(),
      flutterLocalNotificationsPlugin: sl(),
    ),
  );
  sl.registerFactory(() => WalletBloc(getWalletByUser: sl(), createWalletUseCase: sl(),
      inviteMemberUseCase: sl(), changeOwnerUseCase: sl(), deleteUserUseCase: sl()));
  sl.registerFactory(() => RoomBloc(sl()));
  sl.registerFactory(() => BuildingBloc(getBuildingUseCase: sl(), getBuildingsUseCase: sl()));
  sl.registerFactory(() => TransactionBloc(sl(), sl(), sl()));
  sl.registerLazySingleton (() => HouseBloc(getHouseByBuildingUseCase: sl(), getHouseByUseCase: sl()));
  sl.registerFactory(() => PaymentMethodBloc(sl()));
  sl.registerFactory(() => UserBloc(sl(), sl()));
  sl.registerFactory(() => PersonalWalletBloc(getWalletByUser: sl()));
  sl.registerFactory(() => SharedWalletBloc(getWalletByUser: sl()));
  sl.registerFactory(() => ActivityStatusBloc(repository: sl()));
}
