import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
   debugPrint('<======================================================>');
    debugPrint('[REQUEST] | ${options.method.toUpperCase()} | ${options.uri}');
    if (options.headers.isNotEmpty) {
      debugPrint('Headers: ${options.headers}');
    }
    if (options.data != null) {
      debugPrint('Body: ${options.data}');
    }
   debugPrint('<======================================================>');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('<======================================================>');
    debugPrint('[RESPONSE] | ${response.statusCode} | ${response.requestOptions.uri}');
    if (response.data != null) {
     debugPrint('Payload: ${response.data}');
    }
   debugPrint('<======================================================>');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('<======================================================>');
    debugPrint('[ERROR] | ${err.response?.statusCode ?? 'NO_STATUS'} | ${err.requestOptions.uri}');
    debugPrint('Type: ${err.type}');
    debugPrint('Message: ${err.message}');
    if (err.response?.data != null) {
      debugPrint('Error Payload: ${err.response?.data}');
    }
    debugPrint('<======================================================>');
    super.onError(err, handler);
  }
}
