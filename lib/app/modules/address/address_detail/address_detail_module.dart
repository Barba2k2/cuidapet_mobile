import 'package:flutter_modular/flutter_modular.dart';

import 'address_detail_controller.dart';
import 'address_detail_page.dart';

class AddressDetailModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton(
          (i) => AddressDetailController(
            addressService: i(),
          ),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => AddressDetailPage(
            place: args.data,
          ),
        ),
      ];
}
