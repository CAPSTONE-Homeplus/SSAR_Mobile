import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:home_clean/core/constant/api_constant.dart';
import 'package:home_clean/data/datasource/local/auth_local_datasource.dart';
import 'package:home_clean/data/datasource/local/user_local_datasource.dart';
import 'package:home_clean/domain/repositories/authentication_repository.dart';

import '../../data/mappers/user/user_mapper.dart';
import '../../domain/entities/auth/auth.dart';

enum BaseUrlType {
  homeClean,
  vinWallet,
}

final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSource();
final UserLocalDatasource _userLocalDatasource = UserLocalDatasource();
late AuthRepository _authRepository;

Map<String, dynamic> convertToQueryParams(
    [Map<String, dynamic> params = const {}]) {
  Map<String, dynamic> queryParams = Map.from(params);
  return queryParams.map<String, dynamic>(
    (key, value) => MapEntry(
        key,
        value == null
            ? null
            : (value is List)
                ? value.map<String>((e) => e.toString()).toList()
                : value.toString()),
  );
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorizedException extends AppException {
  UnauthorizedException([message]) : super(message, "Unauthorized: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class ExpiredException extends AppException {
  ExpiredException([String? message]) : super(message, "Token Expired: ");
}

// Cơ chế retry request
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor({required this.dio, this.maxRetries = 3});

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && maxRetries > 0) {
      int retryCount = 0;
      while (retryCount < maxRetries) {
        retryCount++;
        try {
          final response = await dio.request(
            err.requestOptions.path,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            ),
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );
          return handler.resolve(response);
        } catch (e) {
          if (retryCount == maxRetries) {
            return super.onError(err, handler);
          }
        }
      }
    }
    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print(
          'REQUEST[${options.method}] => PATH: ${options.path} HEADER: ${options.headers.toString()}');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
          'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    }
    if (kDebugMode) {
      print('DATA: ${response.data}');
    }
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    }
    return super.onError(err, handler);
  }
}

class MyRequest {

  static final Map<BaseUrlType, String> baseUrls = {
    BaseUrlType.homeClean: ApiConstant.homeCleanUrl,
    BaseUrlType.vinWallet: ApiConstant.vinWalletUrl ,
  };

  static BaseOptions getOptions(BaseUrlType urlType) => BaseOptions(
      baseUrl: baseUrls[urlType]!,
      headers: {
        Headers.contentTypeHeader: "application/json",
        Headers.acceptHeader: "application/json",
      },
      connectTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5));

  late Map<BaseUrlType, Dio> _dioInstances;
  BaseUrlType _currentUrlType;

  MyRequest({BaseUrlType initialUrlType = BaseUrlType.homeClean})
      : _currentUrlType = initialUrlType {
    _dioInstances = {};

    // Khởi tạo các instance Dio cho từng BASE URL
    for (var urlType in BaseUrlType.values) {
      var dio = Dio(getOptions(urlType));
      dio.interceptors.add(CustomInterceptors());
      dio.interceptors.add(RetryInterceptor(dio: dio));
      dio.interceptors.add(InterceptorsWrapper(
        onResponse: (e, handler) {
          return handler.next(e);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            print("Unauthorized - Attempting token refresh");

            try {
              final refreshToken = await _authLocalDataSource.getRefreshTokenFromStorage();

              if (refreshToken == null || refreshToken.isEmpty) {
                clearLocalStorageAndLogout();
                return handler.next(e);
              }

              Auth auth = await _authRepository.refreshToken();

              final newToken = auth.accessToken;
              final newRefreshToken = auth.refreshToken;

              if (newToken == null || newRefreshToken == null) {
                clearLocalStorageAndLogout();
                return handler.next(e);
              }
              await _authLocalDataSource.saveTokensToStorage(newToken, newRefreshToken);
              requestObj.setToken = newToken;
              final options = e.requestOptions;
              options.headers["Authorization"] = "Bearer $newToken";
              final response = await request.fetch(options);
              return handler.resolve(response);
            } catch (refreshError) {
              print("Token refresh failed: $refreshError");
              clearLocalStorageAndLogout();
              return handler.next(e);
            }
          } else if (e.response?.statusCode == 400) {
            print("Bad Request");
          } else if (e.response?.statusCode == 500) {
            print("Internal Server Error");
          } else {
            print(e);
          }
          handler.next(e);
        },
      ));
      _dioInstances[urlType] = dio;
    }
  }

  // Lấy instance Dio hiện tại
  Dio get request => _dioInstances[_currentUrlType]!;

  // Đổi BASE URL
  void switchBaseUrl(BaseUrlType urlType) {
    _currentUrlType = urlType;
  }

  // Lấy instance Dio theo loại BASE URL
  Dio getRequestForUrl(BaseUrlType urlType) => _dioInstances[urlType]!;

  // Set token cho tất cả các instance
  set setToken(String? token) {
    for (var dio in _dioInstances.values) {
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      } else {
        dio.options.headers.remove("Authorization");
      }
    }
  }

  // Get token
  String? get getToken {
    return _dioInstances[_currentUrlType]!.options.headers["Authorization"];
  }
}

Future<void> clearLocalStorageAndLogout() async {
  await Future.wait([
    _userLocalDatasource.clearUser(),
    _authLocalDataSource.clearAuth(),
  ]);
}


final requestObj = MyRequest();
final homeCleanRequest = requestObj.request;
final vinWalletRequest = requestObj.getRequestForUrl(BaseUrlType.vinWallet);

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
