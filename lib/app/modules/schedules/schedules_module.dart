import 'package:flutter_modular/flutter_modular.dart';

import 'schedules_page.dart';

class SchedulesModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const SchedulesPage(),
        ),
      ];
}
