import 'dart:developer';

import 'package:google_place/google_place.dart';

import '../../core/database/sqlite_connection_factory.dart';
import '../../core/exceptions/failure.dart';
import '../../core/helpers/environments.dart';
import '../../entity/address_entity.dart';
import '../../models/place_model.dart';
import './address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final SqliteConnectionFactory _sqliteConnectionFactory;

  AddressRepositoryImpl({
    required SqliteConnectionFactory sqliteConnectionFactory,
  }) : _sqliteConnectionFactory = sqliteConnectionFactory;

  @override
  Future<List<PlaceModel>> findAddressByGooglePlaces(
    String addressPattern,
  ) async {
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
        (searchResult) {
          final location = searchResult.geometry?.location;
          final address = searchResult.formattedAddress;

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

  @override
  Future<void> deleteAll() async {
    final sqliteConn = await _sqliteConnectionFactory.openConnection();

    await sqliteConn.delete('address');
  }

  @override
  Future<List<AddressEntity>> getAddress() async {
    final sqliteConn = await _sqliteConnectionFactory.openConnection();

    final result = await sqliteConn.rawQuery('SELECT * FROM address');
    log('Fetched ${result.length} addresses');
    return result.map<AddressEntity>((a) => AddressEntity.fromMap(a)).toList();
  }

  @override
  Future<int> saveAddress(AddressEntity entity) async {
    try {
      final sqliteConn = await _sqliteConnectionFactory.openConnection();
      log('Inserting into address table');

      return await sqliteConn.rawInsert(
        'INSERT INTO address VALUES(?, ?, ?, ?, ?)',
        [
          null,
          entity.address,
          entity.lat,
          entity.lng,
          entity.additional,
        ],
      );
    } catch (e, s) {
      log('Error on AddressRepositoryImpl', error: e, stackTrace: s);
      throw Exception('Error on AddressRepositoryImpl');
    }
  }
}
