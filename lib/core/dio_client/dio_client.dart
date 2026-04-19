import 'package:dio/dio.dart';

import '../api_constants/api_constants.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🌐 REQUEST: ${options.method} ${options.path}');
          print('📦 BODY: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ERROR: ${error.response?.statusCode} ${error.response?.data}');
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}