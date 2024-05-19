import 'package:dio/dio.dart';

import '../../../helpers/constants.dart';
import '../../../local_storage/local_storage.dart';
import '../../../logger/app_logger.dart';

class AuthInterceptors extends Interceptor {
  final LocalStorage _localStorage;
  final AppLogger _log;

  AuthInterceptors({
    required LocalStorage localStorage,
    required AppLogger log,
  })  : _localStorage = localStorage,
        _log = log;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final authRequired =
        options.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] ?? false;

    if (authRequired) {
      final accessToken = await _localStorage.read<String>(
        Constants.LOCAL_STORARE_ACCESS_TOKEN_KEY,
      );

      if (accessToken == null) {
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'Expire Token',
            type: DioExceptionType.cancel,
          ),
        );
      }

      options.headers['Authorization'] = accessToken;
    } else {
      options.headers.remove('Authorization');
    }

    handler.next(options);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   super.onResponse(response, handler);
  // }

  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) {
  //   super.onError(err, handler);
  // }
}
