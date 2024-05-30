import 'dart:convert';

class SupplierCategoryModel {
  int id;
  String name;
  String type;

  SupplierCategoryModel({
    required this.id,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
    };
  }

  factory SupplierCategoryModel.fromMap(Map<String, dynamic> map) {
    return SupplierCategoryModel(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SupplierCategoryModel.fromJson(String source) =>
      SupplierCategoryModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
