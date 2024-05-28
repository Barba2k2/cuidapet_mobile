import 'package:flutter_modular/flutter_modular.dart';

import '../../core/database/sqlite_connection_factory.dart';
import '../../core/local_storage/local_storage.dart';
import '../../core/local_storage/secure_storage/flutter_secure_storage_local_storage_impl.dart';
import '../../core/local_storage/shared_preferences/shared_preferences_local_storage_impl.dart';
import '../../core/logger/app_logger.dart';
import '../../core/logger/logger_app_logger_impl.dart';
import '../../core/rest_client/dio/dio_rest_client.dart';
import '../../core/rest_client/rest_client.dart';
import '../../repositories/address/address_repository.dart';
import '../../repositories/address/address_repository_impl.dart';
import '../../services/address/address_service.dart';
import '../../services/address/address_service_impl.dart';
import 'auth/auth_store.dart';

class CoreModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton(
          (i) => SqliteConnectionFactory(),
          export: true,
        ),
        Bind.lazySingleton<AppLogger>(
          (i) => LoggerAppLoggerImpl(),
          export: true,
        ),
        Bind.lazySingleton<LocalStorage>(
          (i) => SharedPreferencesLocalStorageImpl(),
          export: true,
        ),
        Bind.lazySingleton<LocalSecurityStorage>(
          (i) => FlutterSecureStorageLocalStorageImpl(),
          export: true,
        ),
        Bind.lazySingleton(
          (i) => AuthStore(
            localStorage: i(),
          ),
          export: true,
        ),
        Bind.lazySingleton<RestClient>(
          (i) => DioRestClient(
            localStorage: i(),
            localSecurityStorage: i(),
            log: i(),
            authStore: i(),
          ),
          export: true,
        ),
        Bind.lazySingleton<AddressRepository>(
          (i) => AddressRepositoryImpl(
            sqliteConnectionFactory: i(),
          ),
          export: true,
        ),
        Bind.lazySingleton<AddressService>(
          (i) => AddressServiceImpl(
            addressRepository: i(),
          ),
          export: true,
        ),
      ];
}
