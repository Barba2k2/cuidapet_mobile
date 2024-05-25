import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../life_cycle/controller_life_cycle.dart';

part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store, ControllerLifeCycle {
  @override
  Future<void> onReady() async {
    await _hasRegistredAddress();
  }

  Future<void> _hasRegistredAddress() async {
    await Modular.to.pushNamed('/address/');
  }
}
