import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstant {
  static final String homeCleanUrl = dotenv.env['homeCleanUrl'] ?? 'https://default-homeclean.com/api/v1';
  static final String vinWalletUrl = dotenv.env['vinWalletUrl'] ?? 'https://default-vinwallet.com/api/v1';

  /// Authed
  static const String auth = "/auth";

  /// User
  static const String users = "/users";

  /// Service
  static const String services = "/services";

  /// Service category
  static const String serviceCategories = "/service-categories";

  /// Service activity
  static const String serviceActivities = "/service-activities";

  /// Sub activity
  static const String subActivities = "/sub-activities";

  /// Time slot
  static const String timeSlots = "/time-slots";

  /// Room
  static const String rooms = "/rooms";

  /// Building
  static const String buildings = "/buildings";

  /// Transaction
  static const String transactions = "/transactions";

  /// Order
  static const String orders = "/orders";
}
