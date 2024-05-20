import 'package:firebase_auth/firebase_auth.dart';

import '../../core/exceptions/failure.dart';
import '../../core/exceptions/user_exists_exception.dart';
import '../../core/helpers/constants.dart';
import '../../core/local_storage/local_storage.dart';
import '../../core/logger/app_logger.dart';
import '../../repositories/user/user_repository.dart';
import './user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final AppLogger _log;
  final LocalStorage _localStorage;
  final LocalSecureStorage _localSecureStorage;

  UserServiceImpl({
    required UserRepository userRepository,
    required AppLogger log,
    required LocalStorage localStorage,
    required LocalSecureStorage localSecureStorage,
  })  : _userRepository = userRepository,
        _log = log,
        _localStorage = localStorage,
        _localSecureStorage = localSecureStorage;

  @override
  Future<void> register(String email, String password) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      final userMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);

      if (userMethods.isNotEmpty) {
        throw UserExistsException();
      }

      await _userRepository.register(email, password);

      final userRegisterCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userRegisterCredential.user?.sendEmailVerification();
    } on FirebaseException catch (e, s) {
      _log.error('Error on regisring user on Firebase', e, s);
      throw Failure(message: 'Erro ao cadastrar usuário no Firebase');
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;
      final loginMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);
      if (loginMethods.isEmpty) {
        throw UserExistsException();
      }

      if (loginMethods.contains('password')) {
        final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final userVerified = userCredential.user?.emailVerified ?? false;

        if (!userVerified) {
          userCredential.user?.sendEmailVerification();
          throw Failure(
            message: 'E-mail não confirmado, por favor, verifique seu e-mail',
          );
        }

        final accessToken = await _userRepository.login(email, password);

        await _saveAccessToken(accessToken);

        await _confirmLogin();
      } else {
        _log.error("Login by password hasn't finded");
        throw Failure(
          message:
              'Login não pode ser feito por e-mail e senha, por favor, utilize outro método',
        );
      }
    } on FirebaseAuthException catch (e, s) {
      _log.error(
        'User or password invalid [FirebaseAuthError: ${e.code}]',
        e,
        s,
      );
      throw Failure(message: 'Usuário ou senha inválidos');
    }
  }

  Future<void> _saveAccessToken(String accessToken) =>
      _localStorage.write<String>(
        Constants.LOCAL_STORARE_ACCESS_TOKEN_KEY,
        accessToken,
      );

  Future<void> _confirmLogin() async {
    final confirmLoginModel = await _userRepository.confirmLogin();

    await _saveAccessToken(confirmLoginModel.accessToken);

    await _localSecureStorage.write(
      Constants.LOCAL_STORARE_REFRESH_TOKEN_KEY,
      confirmLoginModel.refreshToken,
    );
  }
}
