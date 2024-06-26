import '../../entity/address_entity.dart';
import '../../models/supplier_category_model.dart';
import '../../models/supplier_model.dart';
import '../../models/supplier_nearby_me_model.dart';
import '../../models/supplier_services_model.dart';
import '../../repositories/supplier/supplier_repository.dart';
import './supplier_service.dart';

class SupplierServiceImpl implements SupplierService {
  final SupplierRepository _repository;

  SupplierServiceImpl({
    required SupplierRepository supplierRepository,
  }) : _repository = supplierRepository;

  @override
  Future<List<SupplierCategoryModel>> getCategories() =>
      _repository.getCategoires();

  @override
  Future<List<SupplierNearbyMeModel>> findNearBy(AddressEntity address) =>
      _repository.findNearby(address);

  @override
  Future<SupplierModel> findById(int id) => _repository.findById(id);

  @override
  Future<List<SupplierServicesModel>> findServices(int supplierId) =>
      _repository.findServices(supplierId);
}
