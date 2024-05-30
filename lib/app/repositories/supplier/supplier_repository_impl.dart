import '../../core/exceptions/failure.dart';
import '../../core/logger/app_logger.dart';
import '../../core/rest_client/rest_client.dart';
import '../../core/rest_client/rest_client_exception.dart';
import '../../models/supplier_category_model.dart';
import './supplier_repository.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final RestClient _restClient;
  final AppLogger _log;

  SupplierRepositoryImpl({
    required RestClient restClient,
    required AppLogger log,
  })  : _restClient = restClient,
        _log = log;

  @override
  Future<List<SupplierCategoryModel>> getCategoires() async {
    try {
      final result = await _restClient.auth().get('/categories/');

      return result.data
          ?.map<SupplierCategoryModel>(
            (categoryResponse) => SupplierCategoryModel.fromMap(
              categoryResponse,
            ),
          )
          .toList();
    } on RestClientException catch (e, s) {
      const message = 'Erro ao buscar categorias dos fornecedores';
      _log.error(message, e, s);
      throw Failure(message: message);
    }
  }
}
