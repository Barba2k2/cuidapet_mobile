class PlaceModel {
  String address;
  double lat;
  double lng;

  PlaceModel({
    required this.address,
    required this.lat,
    required this.lng,
  });

  @override
  String toString() => 'PlaceModel(address: $address, lat: $lat, lng: $lng)';
}
