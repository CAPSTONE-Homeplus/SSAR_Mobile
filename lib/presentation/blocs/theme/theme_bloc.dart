import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences preferences;
  static const THEME_KEY = "THEME_KEY";

  ThemeBloc({required this.preferences})
      : super(ThemeInitial(
          themeData: _getLightTheme(),
          isDarkMode: false,
        )) {
    on<InitializeTheme>(_onInitializeTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  static ThemeData _getLightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.black),
    );
  }

  static ThemeData _getDarkTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
    );
  }

  Future<void> _onInitializeTheme(
      InitializeTheme event, Emitter<ThemeState> emit) async {
    final isDarkMode = preferences.getBool(THEME_KEY) ?? false;
    emit(ThemeInitial(
      themeData: isDarkMode ? _getDarkTheme() : _getLightTheme(),
      isDarkMode: isDarkMode,
    ));
  }

  Future<void> _onToggleTheme(
      ToggleTheme event, Emitter<ThemeState> emit) async {
    final isDarkMode = !state.isDarkMode;
    await preferences.setBool(THEME_KEY, isDarkMode);
    emit(ThemeInitial(
      themeData: isDarkMode ? _getDarkTheme() : _getLightTheme(),
      isDarkMode: isDarkMode,
    ));
  }
}
