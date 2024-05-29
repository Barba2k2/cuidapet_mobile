import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../core/ui/widgets/loader.dart';
import '../../entity/address_entity.dart';
import '../../life_cycle/controller_life_cycle.dart';
import '../../services/address/address_service.dart';

part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store, ControllerLifeCycle {
  final AddressService _addressService;

  HomeControllerBase({
    required AddressService addressService,
  }) : _addressService = addressService;

  @readonly
  AddressEntity? _addressEntity;

  @override
  Future<void> onReady() async {
    Loader.show();
    await _getAddressSelected();
    Loader.hide();
  }

  @action
  Future<void> _getAddressSelected() async {
    _addressEntity ??= await _addressService.getAddressSelected();

    if (_addressEntity == null) {
      await goToAddressPage();
    }
  }

  @action
  Future<void> goToAddressPage() async {
    final address = await Modular.to.pushNamed<AddressEntity>('/address/');
    _addressEntity = address;
  }
}
