import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/logger/app_logger.dart';
import '../../core/ui/widgets/loader.dart';
import '../../core/ui/widgets/messages.dart';
import '../../life_cycle/controller_life_cycle.dart';
import '../../models/supplier_model.dart';
import '../../models/supplier_services_model.dart';
import '../../services/supplier/supplier_service.dart';
import '../schedules/model/schedule_view_model.dart';

part 'supplier_controller.g.dart';

class SupplierController = SupplierControllerBase with _$SupplierController;

abstract class SupplierControllerBase with Store, ControllerLifeCycle {
  final SupplierService _supplierService;
  final AppLogger _log;

  int _supplierId = 0;

  @readonly
  SupplierModel? _supplierModel;

  @readonly
  var _supplierServices = <SupplierServicesModel>[];

  @readonly
  // ignore: prefer_final_fields
  var _servicesSelected = <SupplierServicesModel>[].asObservable();

  SupplierControllerBase({
    required SupplierService supplierService,
    required AppLogger log,
  })  : _supplierService = supplierService,
        _log = log;

  @override
  void onInit([Map<String, dynamic>? params]) {
    _supplierId = params?['supplierId'] ?? 0;
    log('Params: $params');
  }

  @override
  Future<void> onReady() async {
    try {
      Loader.show();
      await Future.wait([
        _findSupplierById(),
        _findSupplierServices(),
      ]);
    } finally {
      Loader.hide();
    }
  }

  @action
  Future<void> _findSupplierById() async {
    try {
      _supplierModel = await _supplierService.findById(_supplierId);
    } catch (e, s) {
      _log.error('Error on find supplier data', e, s);
      Messages.alert('Erro ao buscar dados do fornecedor');
    }
  }

  @action
  Future<void> _findSupplierServices() async {
    try {
      _supplierServices = await _supplierService.findServices(_supplierId);
    } catch (e, s) {
      _log.error('Error on find services of supplier', e, s);
      Messages.alert('Erro ao buscar serviços do fornecedor');
    }
  }

  @action
  void addOrRemoveServices(SupplierServicesModel supplierServicesModel) {
    if (_servicesSelected.contains(supplierServicesModel)) {
      _servicesSelected.remove(supplierServicesModel);
    } else {
      _servicesSelected.add(supplierServicesModel);
    }
  }

  bool isServiceSelected(SupplierServicesModel servicesModel) =>
      _servicesSelected.contains(servicesModel);

  int get totalServicesSelected => _servicesSelected.length;

  Future<void> goToPhoneOrCopyPhoneToClipart() async {
    final phoneUrl = 'tel:${_supplierModel?.phone}';

    if (await canLaunchUrlString(phoneUrl)) {
      await launchUrlString(phoneUrl);
    } else {
      await Clipboard.setData(
        ClipboardData(
          text: _supplierModel?.phone,
        ),
      );
      Messages.info('Telefone copiado para a área de transferência');
    }
  }

  Future<void> goToGeoOrCopyAddressToClipart() async {
    final geoUrl = 'geo:${_supplierModel?.lat}, ${_supplierModel?.lng}';

    if (await canLaunchUrlString(geoUrl)) {
      await launchUrlString(geoUrl);
    } else {
      await Clipboard.setData(
        ClipboardData(
          text: _supplierModel?.address,
        ),
      );
      Messages.info('Endereço copiado para a área de transferência');
    }
  }

  void goToSchedule() {
    Modular.to.pushNamed(
      '/schedules/',
      arguments: ScheduleViewModel(
        supplierId: _supplierId,
        services: _servicesSelected.toList(),
      ),
    );
  }
}
