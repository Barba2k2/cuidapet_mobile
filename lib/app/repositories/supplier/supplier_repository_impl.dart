import 'dart:convert';

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

      if (result.data is String) {
        final decodedData = jsonDecode(result.data) as List;
        return decodedData
            .map<SupplierCategoryModel>(
              (categoryResponse) => SupplierCategoryModel.fromMap(
                categoryResponse,
              ),
            )
            .toList();
      } else if (result.data is List) {
        // Se já for uma lista, apenas faça o mapeamento
        return result.data
            .map<SupplierCategoryModel>(
              (categoryResponse) => SupplierCategoryModel.fromMap(
                categoryResponse,
              ),
            )
            .toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } on RestClientException catch (e, s) {
      const message = 'Erro ao buscar categorias dos fornecedores';
      _log.error(message, e, s);
      throw Failure(message: message);
    }
  }
}
