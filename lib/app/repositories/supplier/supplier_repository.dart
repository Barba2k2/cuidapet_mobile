import '../../entity/address_entity.dart';
import '../../models/supplier_category_model.dart';
import '../../models/supplier_nearby_me_model.dart';

abstract class SupplierRepository {
  Future<List<SupplierCategoryModel>> getCategoires();
  Future<List<SupplierNearbyMeModel>> findNearby(AddressEntity address);
}
