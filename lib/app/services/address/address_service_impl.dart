import 'dart:developer';

import '../../entity/address_entity.dart';
import '../../models/place_model.dart';
import '../../repositories/address/address_repository.dart';
import './address_service.dart';

class AddressServiceImpl implements AddressService {
  final AddressRepository _addressRepository;

  AddressServiceImpl({
    required AddressRepository addressRepository,
  }) : _addressRepository = addressRepository;

  @override
  Future<List<PlaceModel>> findAddressByGooglePlaces(String addressPattern) =>
      _addressRepository.findAddressByGooglePlaces(addressPattern);

  @override
  Future<void> deleteAll() => _addressRepository.deleteAll();

  @override
  Future<List<AddressEntity>> getAddress() => _addressRepository.getAddress();

  @override
  Future<AddressEntity> saveAddress(
    PlaceModel placeModel,
    String additional,
  ) async {
    final addressEntity = AddressEntity(
      address: placeModel.address,
      lat: placeModel.lat,
      lng: placeModel.lng,
      additional: additional,
    );

    var addressId = await _addressRepository.saveAddress(addressEntity);

    return addressEntity.copyWith(id: addressId);
  }
}
