import 'dart:developer';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../life_cycle/controller_life_cycle.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store, ControllerLifeCycle {
  @override
  Future<void> onReady() async {
    await _hasRegistredAddress();
  }

  Future<void> _hasRegistredAddress() async {
    await Modular.to.pushNamed('/address/');
  }
}
