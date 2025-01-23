import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/app_router.dart';
import 'package:home_clean/data/repositories/option_repository_impl.dart';
import 'package:home_clean/data/repositories/service_activity_repository_impl.dart';
import 'package:home_clean/data/repositories/service_category_repository_impl.dart';
import 'package:home_clean/domain/repositories/option_repository.dart';
import 'package:home_clean/domain/repositories/service_activity_repository.dart';
import 'package:home_clean/domain/repositories/service_category_repository.dart';
import 'package:home_clean/domain/repositories/service_repository.dart';
import 'package:home_clean/presentation/blocs/option/option_bloc.dart';
import 'package:home_clean/presentation/blocs/service/service_bloc.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_bloc.dart';
import 'package:home_clean/presentation/blocs/service_category/service_category_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/authentication_repository_impl.dart';
import 'data/repositories/service_repository_impl.dart';
import 'domain/repositories/authentication_repository.dart';
import 'presentation/blocs/authentication/authentication_bloc.dart';
import 'presentation/blocs/internet/internet_bloc.dart';
import 'presentation/blocs/theme/theme_bloc.dart';

final sl = GetIt.instance;
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  setupServiceLocator(prefs);
  runApp(HomeClean(preferences: prefs));
}

void setupServiceLocator(SharedPreferences prefs) {
  // Repositories (sử dụng LazySingleton vì chúng ta muốn tái sử dụng đối tượng)
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl());

  sl.registerLazySingleton<ServiceRepository>(() => ServiceRepositoryImpl());
  sl.registerLazySingleton<ServiceCategoryRepository>(
      () => ServiceCategoryRepositoryImpl());
  sl.registerLazySingleton<ServiceActivityRepository>(
      () => ServiceActivityRepositoryImpl());
  sl.registerLazySingleton<OptionRepository>(() => OptionRepositoryImpl());

  // Blocs (sử dụng Factory vì mỗi bloc sẽ cần một instance mới)
  sl.registerFactory(() => AuthenticationBloc(authenticationRepository: sl()));
  sl.registerFactory(() => InternetBloc());
  sl.registerFactory(() => ThemeBloc(preferences: prefs));
  sl.registerFactory(() => ServiceBloc(serviceRepository: sl()));
  sl.registerCachedFactory(
      () => ServiceCategoryBloc(serviceCategoryRepository: sl()));
  sl.registerCachedFactory(
      () => ServiceActivityBloc(serviceActivityRepository: sl()));
  sl.registerCachedFactory(() => OptionBloc(optionRepository: sl()));
}

class HomeClean extends StatelessWidget {
  final SharedPreferences preferences;

  const HomeClean({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
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
              create: (context) => ServiceBloc(serviceRepository: sl())),
          BlocProvider(
              create: (context) =>
                  ServiceCategoryBloc(serviceCategoryRepository: sl())),
          BlocProvider(
              create: (context) =>
                  ServiceActivityBloc(serviceActivityRepository: sl())),
          BlocProvider(create: (context) => OptionBloc(optionRepository: sl())),
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
