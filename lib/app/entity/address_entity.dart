import 'dart:convert';

class AddressEntity {
  final int? id;
  final String address;
  final double lat;
  final double lng;
  final String additional;

  AddressEntity({
    required this.address,
    required this.lat,
    required this.lng,
    required this.additional,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'address': address,
      'lat': lat,
      'lng': lng,
      'additional': additional,
    };
  }

  factory AddressEntity.fromMap(Map<String, dynamic> map) {
    return AddressEntity(
      id: map['id'] != null ? map['id'] as int : null,
      address: map['address'] as String,
      lat: map['lat'] as double,
      lng: map['lng'] as double,
      additional: map['additional'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressEntity.fromJson(String source) =>
      AddressEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  AddressEntity copyWith({
    int? id,
    String? address,
    double? lat,
    double? lng,
    String? additional,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      additional: additional ?? this.additional,
    );
  }
}
