import 'package:flutter_modular/flutter_modular.dart';

import 'address_page.dart';
import 'widgets/address_search_widget/address_search_controller.dart';

class AddressModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton(
          (i) => AddressSearchController(
            addressService: i(), //$ Core Module
          ),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => const AddressPage(),
        ),
      ];
}
