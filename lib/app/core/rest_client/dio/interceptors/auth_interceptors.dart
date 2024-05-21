import 'package:dio/dio.dart';

import '../../../../modules/core/auth/auth_store.dart';
import '../../../helpers/constants.dart';
import '../../../local_storage/local_storage.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorage _localStorage;
  final AuthStore _authStore;

  AuthInterceptor({
    required LocalStorage localStorage,
    required AuthStore authStore,
  })  : _localStorage = localStorage,
        _authStore = authStore;

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
        _authStore.logout();
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
}
