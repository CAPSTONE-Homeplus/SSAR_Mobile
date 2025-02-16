import 'package:flutter/widgets.dart';

class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double fem = 1;
  static double hem = 1;
  static double ffem = 1;

  static void init(BuildContext context, {double baseWidth = 375.0, double baseHeight = 812.0}) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    fem = screenWidth / baseWidth;
    hem = screenHeight / baseHeight;
    ffem = fem * 0.97;
  }
}
