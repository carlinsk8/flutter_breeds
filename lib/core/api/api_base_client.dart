import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/exception.dart';

abstract class BaseDioClient {
  late Dio _instance;

  Future<String> getToken();
  Future<Dio> getDio([Map<String, dynamic>? cuyApiAux]) async {
    final token = await _getToken();
    final tokenChecked = await checkToken(token);
    _instance = Dio();
    _instance.options.receiveDataWhenStatusError = true;
    _instance.options.headers = {
      if (tokenChecked.isNotEmpty) 'x-api-key': tokenChecked,
    };

    if (kDebugMode) _instance.interceptors.add(LogInterceptor());

    return _instance;
  }

  Future<String> checkToken(String token) async => _getToken();

  Future<String> _getToken() async {
    final String token = await getToken();
    return token;
  }

  Future<Response> getUri(String url,
      {Map<String, dynamic>? queryParameters}) async {
    await getDio();
    return _processResponse(
        () => _instance.get(url, queryParameters: queryParameters));
  }

  Future<Response> _processResponse(DioAction action) async {
    try {
      final response = await action();
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        final response = e.response;
        final statusCode = response?.statusCode;

        switch (statusCode) {
          case HttpStatus.unauthorized:
            throw UnauthorisedException(json.encode(response?.data));
          default:
            throw ServerException(json.encode(response?.data));
        }
      } else {
        throw ServerException(
            'Error occured while Communication with Server');
      }
        }
  }
}

typedef DioAction = Future<Response> Function();
