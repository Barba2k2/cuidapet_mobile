import 'package:flutter_modular/flutter_modular.dart';

import 'register_controller.dart';
import 'register_page.dart';

class RegisterModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton(
          (i) => RegisterController(
            userService: i(), //$ AuthModule
            log: i(), //$ CoreModule
          ),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => const RegisterPage(),
        ),
      ];
}
