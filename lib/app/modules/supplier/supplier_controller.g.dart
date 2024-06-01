// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SupplierController on SupplierControllerBase, Store {
  late final _$_supplierModelAtom =
      Atom(name: 'SupplierControllerBase._supplierModel', context: context);

  SupplierModel? get supplierModel {
    _$_supplierModelAtom.reportRead();
    return super._supplierModel;
  }

  @override
  SupplierModel? get _supplierModel => supplierModel;

  @override
  set _supplierModel(SupplierModel? value) {
    _$_supplierModelAtom.reportWrite(value, super._supplierModel, () {
      super._supplierModel = value;
    });
  }

  late final _$_supplierServicesAtom =
      Atom(name: 'SupplierControllerBase._supplierServices', context: context);

  List<SupplierServicesModel> get supplierServices {
    _$_supplierServicesAtom.reportRead();
    return super._supplierServices;
  }

  @override
  List<SupplierServicesModel> get _supplierServices => supplierServices;

  @override
  set _supplierServices(List<SupplierServicesModel> value) {
    _$_supplierServicesAtom.reportWrite(value, super._supplierServices, () {
      super._supplierServices = value;
    });
  }

  late final _$_findSupplierByIdAsyncAction =
      AsyncAction('SupplierControllerBase._findSupplierById', context: context);

  @override
  Future<void> _findSupplierById() {
    return _$_findSupplierByIdAsyncAction.run(() => super._findSupplierById());
  }

  late final _$_findSupplierServicesAsyncAction = AsyncAction(
      'SupplierControllerBase._findSupplierServices',
      context: context);

  @override
  Future<void> _findSupplierServices() {
    return _$_findSupplierServicesAsyncAction
        .run(() => super._findSupplierServices());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
