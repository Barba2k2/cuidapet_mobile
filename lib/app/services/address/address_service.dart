import '../../entity/address_entity.dart';
import '../../models/place_model.dart';

abstract class AddressService {
  Future<List<PlaceModel>> findAddressByGooglePlaces(String addressPattern);
  Future<List<AddressEntity>> getAddress();
  Future<void> deleteAll();
  Future<AddressEntity> saveAddress(PlaceModel placeModel, String additional);
  Future<void> selectAddress(AddressEntity addressEntity);
  Future<AddressEntity?> getAddressSelected();  
}
