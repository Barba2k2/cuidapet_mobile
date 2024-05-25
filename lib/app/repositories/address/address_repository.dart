import '../../models/place_model.dart';

abstract class AddressRepository {
  Future<List<PlaceModel>> findAddressByGooglePlaces(String addressPattern);
}
