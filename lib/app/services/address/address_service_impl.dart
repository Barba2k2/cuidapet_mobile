import '../../core/helpers/constants.dart';
import '../../core/local_storage/local_storage.dart';
import '../../entity/address_entity.dart';
import '../../models/place_model.dart';
import '../../repositories/address/address_repository.dart';
import './address_service.dart';

class AddressServiceImpl implements AddressService {
  final AddressRepository _addressRepository;
  final LocalStorage _localStorage;

  AddressServiceImpl({
    required AddressRepository addressRepository,
    required LocalStorage localStorage,
  })  : _addressRepository = addressRepository,
        _localStorage = localStorage;

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

  @override
  Future<AddressEntity?> getAddressSelected() async {
    final addressJson = await _localStorage.read<String>(
      Constants.LOCAL_STORAGE_DEFAULT_ADDRESS_DATA_KEY,
    );

    if (addressJson != null) {
      return AddressEntity.fromJson(addressJson);
    }

    return null;
  }

  @override
  Future<void> selectAddress(AddressEntity addressEntity) async {
    await _localStorage.write<String>(
      Constants.LOCAL_STORAGE_DEFAULT_ADDRESS_DATA_KEY,
      addressEntity.toJson(),
    );
  }
}
