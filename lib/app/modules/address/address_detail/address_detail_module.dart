import 'package:flutter_modular/flutter_modular.dart';

import 'address_detail_page.dart';

class AddressDetailModule extends Module {
  
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
