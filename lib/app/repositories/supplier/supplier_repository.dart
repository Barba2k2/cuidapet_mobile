import '../../entity/address_entity.dart';
import '../../models/supplier_category_model.dart';
import '../../models/supplier_model.dart';
import '../../models/supplier_nearby_me_model.dart';
import '../../models/supplier_services_model.dart';

abstract class SupplierRepository {
  Future<List<SupplierCategoryModel>> getCategoires();
  Future<List<SupplierNearbyMeModel>> findNearby(AddressEntity address);
  Future<SupplierModel> findById(int id);
  Future<List<SupplierServicesModel>> findServices(int supplierId);
}
