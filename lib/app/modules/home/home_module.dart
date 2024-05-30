import 'package:flutter_modular/flutter_modular.dart';

import '../core/supplier/supplier_core_module.dart';
import 'home_controller.dart';
import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton(
      (i) => HomeController(
        addressService: i(),
      ),
    ),
  ];

  @override
  List<Module> get imports => [
        SupplierCoreModule(),
      ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Modular.initialRoute,
      child: (_, __) => const HomePage(),
    ),
  ];
}
