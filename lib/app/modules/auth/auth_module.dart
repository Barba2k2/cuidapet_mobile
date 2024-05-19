import 'package:flutter_modular/flutter_modular.dart';

import '../../repositories/user/user_repository.dart';
import '../../repositories/user/user_repository_impl.dart';
import '../../services/user/user_service.dart';
import '../../services/user/user_service_impl.dart';
import 'home/auth_home_page.dart';
import 'login/login_module.dart';
import 'register/register_module.dart';

class AuthModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton<UserRepository>(
          (i) => UserRepositoryImpl(
            log: i(), //$ CoreModule
            restClient: i(), //$ CoreModule
          ),
        ),
        Bind.lazySingleton<UserService>(
          (i) => UserServiceImpl(
            log: i(), //$ CoreModule
            userRepository: i(), //$ AuthModule
            localStorage: i(), //$ CoreModule
          ),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => AuthHomePage(
            authStore: Modular.get(),
          ),
        ),
        ModuleRoute(
          '/login/',
          module: LoginModule(),
        ),
        ModuleRoute(
          '/register/',
          module: RegisterModule(),
        ),
      ];
}
