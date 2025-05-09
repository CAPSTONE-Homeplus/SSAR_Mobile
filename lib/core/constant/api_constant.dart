import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstant {
  static final String homeCleanUrl = dotenv.env['HOME_CLEAN_URL'] ?? 'https://default-homeclean.com/api/v1';
  static final String vinWalletUrl = dotenv.env['VIN_WALLET_URL'] ?? 'https://default-vinwallet.com/api/v1';
  static final String vinLaundryUrl = dotenv.env['VIN_LAUNDRY_URL'] ?? 'https://default-vinlaundry.com/api/v1';

  /// Authed
  static const String auth = "/auth";

  /// User
  static const String users = "/users";

  /// Service
  static const String services = "/services";

  /// Service status
  static const String serviceStatus = "/services-by-status";

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

  /// Payment method
  static const String paymentMethods = "/payment-methods";

  /// Houses
  static const String houses = "/houses";

  /// Wallet
  static const String wallets = "/wallets";

  /// Staff
  static const String staff = "/staffs";

  /// Laundry service type
  static const String laundryServiceTypes = "/service-types";

  /// Additional service
  static const String additionalServices = "/additional-services";

  /// Feedback
  static const String feedbacks = "/feedbacks";

  /// Service House Type
  static const String serviceHouseTypes = "/service-in-house-types";

  static const String getTransactionByUser = "https://vinwallet.onrender.com/api/v1/users/{id}/transactions";
  static const String getTransactionByUserWallet = "https://vinwallet.onrender.com/api/v1/users/{id}/transactions{walletId}";
}
