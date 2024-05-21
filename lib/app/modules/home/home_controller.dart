import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../life_cycle/controller_life_cycle.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store, ControllerLifeCycle {
  @override
  void onInit([Map<String, dynamic>? params]) {
    log('OnInit called');
  }

  @override
  void onReady() {
    log('onReady called');
    super.onReady();
  }
}
