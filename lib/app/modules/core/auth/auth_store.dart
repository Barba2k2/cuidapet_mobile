import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

import '../../../core/helpers/constants.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../models/user_model.dart';
import '../../../services/address/address_service.dart';
part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  final LocalStorage _localStorage;
  final LocalSecurityStorage _localSecurityStorage;
  final AddressService _addressService;

  AuthStoreBase({
    required LocalStorage localStorage,
    required LocalSecurityStorage localSecurityStorage,
    required AddressService addressService,
  })  : _localStorage = localStorage,
        _localSecurityStorage = localSecurityStorage,
        _addressService = addressService;

  @readonly
  UserModel? _userLogged;

  @action
  Future<void> loadUserLogged() async {
    //# User Logged
    final userModelJson = await _localStorage.read<String>(
      Constants.LOCAL_STORARE_USER_LOGGED_DATA_KEY,
    );

    if (userModelJson != null) {
      _userLogged = UserModel.fromJson(userModelJson);
    } else {
      _userLogged = UserModel.empty();
    }

    FirebaseAuth.instance.authStateChanges().listen(
      (user) async {
        if (user == null) {
          await logout();
        }
      },
    );
  }

  @action
  Future<void> logout() async {
    await _localStorage.clear();
    await _localSecurityStorage.clear();
    await _addressService.deleteAll();
    _userLogged = UserModel.empty();
  }
}
