import '../../models/place_model.dart';

abstract class AddressService {
  Future<List<PlaceModel>> findAddressByGooglePlaces1(String addressPattern);
}
