import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  final Connectivity _connectivity;

  // Dependency injection for better testability
  NetworkHelper({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Checks if the device has an active internet connection
  /// Returns true if connected to WiFi or mobile data
  Future<bool> checkInternetConnection() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet);
  }

  /// More reliable check that verifies if we can actually reach the internet
  /// This will actually try to connect to a reliable host
  Future<bool> hasInternetAccess() async {
    if (!await checkInternetConnection()) {
      return false;
    }

    try {
      // Try to connect to Google's DNS server
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Stream of connectivity changes that can be listened to
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  /// Check connection and return connection type
  Future<List<String>> getConnectionTypes() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    List<String> connectionTypes = [];

    for (var result in results) {
      switch (result) {
        case ConnectivityResult.wifi:
          connectionTypes.add('WiFi');
          break;
        case ConnectivityResult.mobile:
          connectionTypes.add('Mobile Data');
          break;
        case ConnectivityResult.ethernet:
          connectionTypes.add('Ethernet');
          break;
        case ConnectivityResult.bluetooth:
          connectionTypes.add('Bluetooth');
          break;
        case ConnectivityResult.none:
          connectionTypes.add('No Connection');
          break;
        default:
          connectionTypes.add('Unknown');
          break;
      }
    }

    return connectionTypes.isEmpty ? ['No Connection'] : connectionTypes;
  }

  /// Determine if connection is a metered connection (mobile data)
  Future<bool> isMeteredConnection() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile);
  }

  /// Get primary connection type (prioritizing WiFi > Ethernet > Mobile)
  Future<String> getPrimaryConnectionType() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();

    if (results.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else if (results.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    } else if (results.contains(ConnectivityResult.bluetooth)) {
      return 'Bluetooth';
    } else {
      return 'No Connection';
    }
  }
}