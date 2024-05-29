import 'package:flutter_modular/flutter_modular.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';

import '../../core/ui/widgets/loader.dart';
import '../../entity/address_entity.dart';
import '../../life_cycle/controller_life_cycle.dart';
import '../../models/place_model.dart';
import '../../services/address/address_service.dart';

part 'address_controller.g.dart';

class AddressController = AddressControllerBase with _$AddressController;

abstract class AddressControllerBase extends ControllerLifeCycle with Store {
  @readonly
  var _addresses = <AddressEntity>[];

  @readonly
  var _locationServiceUnavailable = false;

  @readonly
  LocationPermission? _locationPermission;

  @readonly
  PlaceModel? _placeModel;

  final AddressService _addressService;

  AddressControllerBase({
    required AddressService addressService,
  }) : _addressService = addressService;

  @override
  void onReady() {
    getAddresses();
  }

  @action
  Future<void> getAddresses() async {
    Loader.show();
    _addresses = await _addressService.getAddress();
    Loader.hide();
  }

  @action
  Future<void> myLocation() async {
    _locationPermission = null;
    _locationServiceUnavailable = false;

    final serviceEnable = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnable) {
      _locationServiceUnavailable = true;
      return;
    }
    final locationPermission = await Geolocator.checkPermission();

    switch (locationPermission) {
      case LocationPermission.denied:
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _locationPermission = permission;
          return;
        }
        break;
      case LocationPermission.deniedForever:
        _locationPermission = locationPermission;
        return;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
      case LocationPermission.unableToDetermine:
        break;
    }

    Loader.show();

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final placemark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    
    final place = placemark.first;

    final address = '${place.thoroughfare} ${place.subThoroughfare}';

    final placeModel = PlaceModel(
      address: address,
      lat: position.latitude,
      lng: position.longitude,
    );

    Loader.hide();

    goToAddressDetail(placeModel);
  }

  void goToAddressDetail(PlaceModel place) {
    Modular.to.pushNamed(
      '/address/detail/',
      arguments: place,
    );
  }
}
