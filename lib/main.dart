import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:home_clean/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/authentication_repository_impl.dart';
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
  runApp(MyApp(preferences: prefs));
}

void setupServiceLocator(SharedPreferences prefs) {
  // Repositories
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl());

  // Blocs
  sl.registerFactory(() => AuthenticationBloc(authenticationRepository: sl()));

  // Data sources
  sl.registerSingleton<SharedPreferences>(prefs);
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;

  const MyApp({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
            create: (_) => sl<AuthenticationRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => InternetBloc()),
          BlocProvider(
            create: (context) => ThemeBloc(preferences: preferences),
          ),
          BlocProvider(
            create: (context) =>
                AuthenticationBloc(authenticationRepository: sl()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return GetMaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Home Clean',
              theme: state.themeData,
              getPages: AppRouter.routes,
              initialRoute: '/login',
            );
          },
        ),
      ),
    );
  }
}
