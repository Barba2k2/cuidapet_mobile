import 'package:mobx/mobx.dart';

import '../../../core/ui/widgets/loader.dart';
import '../../../entity/address_entity.dart';
import '../../../models/place_model.dart';
import '../../../services/address/address_service.dart';

part 'address_detail_controller.g.dart';

class AddressDetailController = AddressDetailControllerBase
    with _$AddressDetailController;

abstract class AddressDetailControllerBase with Store {
  final AddressService _addressService;

  @readonly
  AddressEntity? _addressEntity;

  AddressDetailControllerBase({
    required AddressService addressService,
  }) : _addressService = addressService;

  Future<void> saveAddress(PlaceModel placeModel, String additional) async {
    Loader.show();
    final addressEntity = await _addressService.saveAddress(
      placeModel,
      additional,
    );
    _addressEntity = addressEntity;

    Loader.hide();
  }
}
