import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../../core/exceptions/failure.dart';
import '../../core/exceptions/user_exists_exception.dart';
import '../../core/exceptions/user_not_exists_exception.dart';
import '../../core/helpers/constants.dart';
import '../../core/local_storage/local_storage.dart';
import '../../core/logger/app_logger.dart';
import '../../models/social_login_type.dart';
import '../../models/social_network_model.dart';
import '../../repositories/social/social_repository.dart';
import '../../repositories/user/user_repository.dart';
import './user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final AppLogger _log;
  final LocalStorage _localStorage;
  final LocalSecureStorage _localSecureStorage;
  final SocialRepository _socialRepository;

  UserServiceImpl({
    required UserRepository userRepository,
    required AppLogger log,
    required LocalStorage localStorage,
    required LocalSecureStorage localSecureStorage,
    required SocialRepository socialRepository,
  })  : _userRepository = userRepository,
        _log = log,
        _localStorage = localStorage,
        _localSecureStorage = localSecureStorage,
        _socialRepository = socialRepository;

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

        await _getUserData();
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

  Future<void> _getUserData() async {
    final userModel = await _userRepository.getUserLogged();

    await _localStorage.write<String>(
      Constants.LOCAL_STORARE_USER_LOGGED_DATA_KEY,
      userModel.toJson(),
    );
  }

  @override
  Future<void> socialLogin(SocialLoginType socialLoginType) async {
    try {
      final SocialNetworkModel socialModel;
      final AuthCredential authCredential;
      final firebaseAuth = FirebaseAuth.instance;

      switch (socialLoginType) {
        case SocialLoginType.facebook:
          throw Failure(
            message: 'Login com Facebook não implementado',
          );
        case SocialLoginType.google:
          socialModel = await _socialRepository.googleLogin();
          authCredential = GoogleAuthProvider.credential(
            accessToken: socialModel.accessToken,
            idToken: socialModel.id,
          );
          break;
      }

      final loginMethods = await firebaseAuth.fetchSignInMethodsForEmail(
        socialModel.email,
      );

      final methodCheck = _getMethodToSocialLoginType(socialLoginType);

      if (loginMethods.isNotEmpty && !loginMethods.contains(methodCheck)) {
        throw Failure(
          message:
              'Login não pode ser feito por $methodCheck, por favor, utilize outro método',
        );
      }

      await firebaseAuth.signInWithCredential(authCredential);

      final accessToken = await _userRepository.loginSocial(socialModel);

      await _saveAccessToken(accessToken);

      await _confirmLogin();

      await _getUserData();
    } on FirebaseAuthException catch (e, s) {
      _log.error('Error on login with $socialLoginType', e, s);
      throw Failure(message: 'Erro ao realizar login');
    } on PlatformException catch (e, s) {
      _log.error('PlatformException on login with $socialLoginType', e, s);
      throw Failure(message: 'Erro ao realizar login');
    } catch (e, s) {
      _log.error('Unknown error on login with $socialLoginType', e, s);
      throw Failure(message: 'Erro desconhecido ao realizar login');
    }
  }

  String _getMethodToSocialLoginType(SocialLoginType socialLoginType) {
    switch (socialLoginType) {
      case SocialLoginType.facebook:
        return 'facebook.com';
      case SocialLoginType.google:
        return 'google.com';
    }
  }
}
