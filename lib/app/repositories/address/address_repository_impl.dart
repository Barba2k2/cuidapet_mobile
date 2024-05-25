import 'package:google_place/google_place.dart';

import '../../core/exceptions/failure.dart';
import '../../core/helpers/environments.dart';
import '../../models/place_model.dart';
import './address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  @override
  Future<List<PlaceModel>> findAddressByGooglePlaces(
      String addressPattern) async {
    final googleApiKey = Environments.param('google_api_key');

    if (googleApiKey == null) {
      throw Failure(message: 'Google API Key not found');
    }

    final googlePlace = GooglePlace(googleApiKey);

    final addressResult = await googlePlace.search.getTextSearch(
      addressPattern,
    );

    final candidates = addressResult?.results;

    if (candidates != null) {
      return candidates.map<PlaceModel>(
        (serachResult) {
          final location = serachResult.geometry?.location;
          final address = serachResult.formattedAddress;

          return PlaceModel(
            address: address ?? '',
            lat: location?.lat ?? 0,
            lng: location?.lng ?? 0,
          );
        },
      ).toList();
    }

    return <PlaceModel>[];
  }
}
