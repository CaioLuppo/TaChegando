import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

/// Interceptador que faz log via debugPrint da comunicação
class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    debugPrint("---- REQUEST ----");
    debugPrint('URL: ${data.url.toString()}');
    debugPrint('HEADERS: ${data.headers.toString()}');
    debugPrint('BODY: ${data.body.toString()}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    debugPrint("---- RESPONSE ----");
    debugPrint("STATUS CODE: ${data.statusCode}");
    debugPrint('HEADERS: ${data.headers.toString()}');
    debugPrint('BODY: ${data.body.toString()}');
    return data;
  }
}