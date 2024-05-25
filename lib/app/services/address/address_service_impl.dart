import '../../models/place_model.dart';
import '../../repositories/address/address_repository.dart';
import './address_service.dart';

class AddressServiceImpl implements AddressService {
  final AddressRepository _addressRepository;

  AddressServiceImpl({
    required AddressRepository addressRepository,
  }) : _addressRepository = addressRepository;

  @override
  Future<List<PlaceModel>> findAddressByGooglePlaces1(String addressPattern) =>
      _addressRepository.findAddressByGooglePlaces(addressPattern);
}
