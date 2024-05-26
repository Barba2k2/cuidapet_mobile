import 'package:dio/dio.dart';

import '../../../modules/core/auth/auth_store.dart';
import '../../helpers/constants.dart';
import '../../helpers/environments.dart';
import '../../local_storage/local_storage.dart';
import '../../logger/app_logger.dart';
import '../rest_client.dart';
import '../rest_client_exception.dart';
import '../rest_client_response.dart';
import 'interceptors/auth_interceptors.dart';
import 'interceptors/auth_refresh_token_interceptor.dart';
import 'dart:async';

class DioRestClient implements RestClient {
  late Dio _dio;
  late BaseOptions _options;
  final Completer<void> _completer = Completer<void>();

  DioRestClient({
    required AppLogger log,
    required LocalStorage localStorage,
    required LocalSecurityStorage localSecurityStorage,
    BaseOptions? options,
    required AuthStore authStore,
  }) {
    _initializeOptions().then((opts) {
      _options = opts;
      _dio = Dio(options ?? _options);
      _dio.interceptors.addAll([
        AuthInterceptor(
          localStorage: localStorage,
          authStore: authStore,
        ),
        AuthRefreshTokenInterceptor(
          localStorage: localStorage,
          localSecurityStorage: localSecurityStorage,
          log: log,
          restClient: this,
          authStore: authStore,
        ),
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      ]);
      _completer.complete();
    });
  }

  Future<BaseOptions> _initializeOptions() async {
    final baseUrl = Environments.param(Constants.ENV_BASE_URL_KEY) ?? '';
    final connectTimeoutString = Environments.param(
            Constants.ENV_REST_CLIENT_CONNECT_TIMEOUT_KEY) ??
        '0';
    final receiveTimeoutString = Environments.param(
            Constants.ENV_REST_CLIENT_RECEIVE_TIMEOUT_KEY) ??
        '0';

    final connectTimeout = int.tryParse(connectTimeoutString) ?? 0;
    final receiveTimeout = int.tryParse(receiveTimeoutString) ?? 0;

    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
    );
  }

  Future<void> _waitForInitialization() async {
    if (!_completer.isCompleted) {
      await _completer.future;
    }
  }

  @override
  RestClient auth() {
    _options.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] = true;
    return this;
  }

  @override
  RestClient unauth() {
    _options.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] = false;
    return this;
  }

  @override
  Future<RestClientResponse<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    await _waitForInitialization();
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );
      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioException catch (e) {
      throw RestClientException(
        message: e.response?.statusMessage,
        statusCode: e.response?.statusCode,
        error: e.error,
        response: _dioErrorConverter(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    await _waitForInitialization();
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );
      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioException catch (e) {
      throw RestClientException(
        message: e.response?.statusMessage,
        statusCode: e.response?.statusCode,
        error: e.error,
        response: _dioErrorConverter(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    await _waitForInitialization();
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );
      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioException catch (e) {
      throw RestClientException(
        message: e.response?.statusMessage,
        statusCode: e.response?.statusCode,
        error: e.error,
        response: _dioErrorConverter(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    await _waitForInitialization();
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );
      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioException catch (e) {
      throw RestClientException(
        message: e.response?.statusMessage,
        statusCode: e.response?.statusCode,
        error: e.error,
        response: _dioErrorConverter(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    await _waitForInitialization();
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );
      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioException catch (e) {
      throw RestClientException(
        message: e.response?.statusMessage,
        statusCode: e.response?.statusCode,
        error: e.error,
        response: _dioErrorConverter(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> request<T>(
    String path, {
    data,
    required String method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    await _waitForInitialization();
    try {
      final response = await _dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers, method: method),
      );
      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioException catch (e) {
      throw RestClientException(
        message: e.response?.statusMessage,
        statusCode: e.response?.statusCode,
        error: e.error,
        response: _dioErrorConverter(e.response),
      );
    }
  }

  RestClientResponse<T> _dioErrorConverter<T>(Response? response) {
    return RestClientResponse<T>(
      data: response?.data,
      statusCode: response?.statusCode,
      statusMessage: response?.statusMessage,
    );
  }
}
