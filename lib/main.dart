import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/app_router.dart';
import 'package:home_clean/data/datasource/service_local_data_source.dart';
import 'package:home_clean/data/repositories/equipment_supply/equipment_supply_repository_impl.dart';
import 'package:home_clean/data/repositories/extra_service/extra_service_repository_impl.dart';
import 'package:home_clean/data/repositories/option/option_repository_impl.dart';
import 'package:home_clean/data/repositories/service_activity/service_activity_repository_impl.dart';
import 'package:home_clean/data/repositories/service_category/service_category_repository_impl.dart';
import 'package:home_clean/data/repositories/sub_activity/sub_activity_repository_impl.dart';
import 'package:home_clean/data/repositories/time_slot/time_slot_repository_impl.dart';
import 'package:home_clean/domain/usecases/equipment_supply/get_equipment_supplies_usecase.dart';
import 'package:home_clean/domain/usecases/extra_service/get_extra_service_usecase.dart';
import 'package:home_clean/domain/usecases/option/get_options_usecase.dart';
import 'package:home_clean/domain/usecases/service/clear_selected_service_ids.dart';
import 'package:home_clean/domain/usecases/service/get_selected_service_ids.dart';
import 'package:home_clean/domain/usecases/service/save_selected_service_ids.dart';
import 'package:home_clean/presentation/blocs/equipment/equipment_supply_bloc.dart';
import 'package:home_clean/presentation/blocs/extra_service/extra_service_bloc.dart';
import 'package:home_clean/presentation/blocs/option/option_bloc.dart';
import 'package:home_clean/presentation/blocs/service/service_bloc.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_bloc.dart';
import 'package:home_clean/presentation/blocs/service_category/service_category_bloc.dart';
import 'package:home_clean/presentation/blocs/sub_activity/sub_activity_bloc.dart';
import 'package:home_clean/presentation/blocs/time_slot/time_slot_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/auth/authentication_repository.dart';
import 'data/repositories/auth/authentication_repository_impl.dart';
import 'data/repositories/equipment_supply/equipment_supply_repository.dart';
import 'data/repositories/extra_service/extra_service_repository.dart';
import 'data/repositories/option/option_repository.dart';
import 'data/repositories/service/service_repository.dart';
import 'data/repositories/service/service_repository_impl.dart';
import 'data/repositories/service_activity/service_activity_repository.dart';
import 'data/repositories/service_category/service_category_repository.dart';
import 'data/repositories/sub_activity/sub_activity_repository.dart';
import 'data/repositories/time_slot/time_slot_repository.dart';
import 'domain/usecases/service_activity/get_service_activities_by_service_usecase.dart';
import 'domain/usecases/service_category/get_service_by_service_category_usecase.dart';
import 'domain/usecases/service_category/get_service_categories_usecase.dart';
import 'domain/usecases/sub_activity/get_sub_activities_usecase.dart';
import 'domain/usecases/time_slot/get_time_slots_usecase.dart';
import 'presentation/blocs/authentication/authentication_bloc.dart';
import 'presentation/blocs/internet/internet_bloc.dart';
import 'presentation/blocs/theme/theme_bloc.dart';

final sl = GetIt.instance;
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('vi_VN', null);

  // cho doi khoi tao DI
  await setupServiceLocator();

  runApp(HomeClean(preferences: sl<SharedPreferences>()));
}

Future<void> setupServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // LocalDataSources
  sl.registerLazySingleton<ServiceLocalDataSource>(
    () => ServiceLocalDataSource(sharedPreferences: sl()),
  );

  // Repositories (sử dụng LazySingleton vì chúng ta muốn tái sử dụng đối tượng)
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl());

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
  sl.registerCachedFactory<EquipmentSupplyRepository>(
      () => EquipmentSupplyRepositoryImpl());
  sl.registerCachedFactory<TimeSlotRepository>(() => TimeSlotRepositoryImpl());

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

  // Blocs (sử dụng Factory vì mỗi bloc sẽ cần một instance mới)
  sl.registerFactory(() => AuthenticationBloc(authenticationRepository: sl()));
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => InternetBloc()),
          BlocProvider(
              create: (context) => ThemeBloc(preferences: preferences)),
          BlocProvider(
              create: (context) =>
                  AuthenticationBloc(authenticationRepository: sl())),
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
              initialRoute: AppRouter.routeSplash,
            );
          },
        ),
      ),
    );
  }
}
