import '../../entity/address_entity.dart';
import '../../models/place_model.dart';

abstract class AddressRepository {
  Future<List<PlaceModel>> findAddressByGooglePlaces(String addressPattern);
  Future<List<AddressEntity>> getAddress();
  Future<int> saveAddress(AddressEntity entity);
  Future<void> deleteAll();
}
