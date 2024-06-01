import 'dart:convert';

import '../../core/exceptions/failure.dart';
import '../../core/logger/app_logger.dart';
import '../../core/rest_client/rest_client.dart';
import '../../core/rest_client/rest_client_exception.dart';
import '../../entity/address_entity.dart';
import '../../models/supplier_category_model.dart';
import '../../models/supplier_model.dart';
import '../../models/supplier_nearby_me_model.dart';
import '../../models/supplier_services_model.dart';
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

  @override
  Future<List<SupplierNearbyMeModel>> findNearby(AddressEntity address) async {
    try {
      final result = await _restClient.auth().get(
        '/suppliers/',
        queryParameters: {
          'lat': address.lat,
          'lng': address.lng,
        },
      );

      if (result.data is String) {
        // Decodifique a string JSON para uma lista
        final decodedData = json.decode(result.data) as List;
        return decodedData
            .map<SupplierNearbyMeModel>(
              (supplierResponse) => SupplierNearbyMeModel.fromMap(
                supplierResponse,
              ),
            )
            .toList();
      } else if (result.data is List) {
        // Se já for uma lista, apenas faça o mapeamento
        return result.data
            .map<SupplierNearbyMeModel>(
              (supplierResponse) => SupplierNearbyMeModel.fromMap(
                supplierResponse,
              ),
            )
            .toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } on RestClientException catch (e, s) {
      const message = 'Erro ao buscar fornecedores perto de mim';
      _log.error(message, e, s);
      throw Failure(message: message);
    }
  }

  @override
  Future<SupplierModel> findById(int id) async {
    try {
      final result = await _restClient.auth().get('/suppliers/$id');
      return SupplierModel.fromMap(result.data);
    } on RestClientException catch (e, s) {
      _log.error('Error on find supplier data by id', e, s);
      throw Failure(message: 'Erro ao buscar dados do fornecedor por id');
    }
  }

  @override
  Future<List<SupplierServicesModel>> findServices(int supplierId) async {
    try {
      final result = await _restClient.auth().get(
            '/suppliers/$supplierId/services',
          );

      return result.data
              ?.map<SupplierServicesModel>(
                (jService) => SupplierCategoryModel.fromMap(jService),
              )
              .toList() ??
          <SupplierServicesModel>[];
    } on RestClientException catch (e, s) {
      _log.error('Error on find service of supplier', e, s);
      throw Failure(message: 'Erro ao buscar serviços do fornecedor');
    }
  }
}
