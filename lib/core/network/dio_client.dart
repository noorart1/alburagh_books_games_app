import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base URL confirmed by tracing `Helpers/WebService.java` and by fetching
/// the live `/content_list` endpoint directly (see `AR_WEB_SERVICE_ADDRESS`
/// in the original Java source).
const String apiBaseUrl = 'https://alburagh.com/app/abrest';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));
  }

  return dio;
});
