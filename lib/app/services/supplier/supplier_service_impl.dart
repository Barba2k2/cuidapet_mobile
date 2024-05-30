import '../../models/supplier_category_model.dart';
import '../../repositories/supplier/supplier_repository.dart';
import './supplier_service.dart';

class SupplierServiceImpl implements SupplierService {
  final SupplierRepository _repository;

  SupplierServiceImpl({
    required SupplierRepository supplierRepository,
  }) : _repository = supplierRepository;

  @override
  Future<List<SupplierCategoryModel>> getCategoires() =>
      _repository.getCategoires();
}
