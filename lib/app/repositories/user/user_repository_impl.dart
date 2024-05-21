import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/exceptions/failure.dart';
import '../../core/exceptions/user_exists_exception.dart';
import '../../core/logger/app_logger.dart';
import '../../core/rest_client/rest_client.dart';
import '../../core/rest_client/rest_client_exception.dart';
import '../../models/confirm_login_model.dart';
import '../../models/social_network_model.dart';
import '../../models/user_model.dart';
import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient _restClient;
  final AppLogger _log;

  UserRepositoryImpl({
    required RestClient restClient,
    required AppLogger log,
  })  : _restClient = restClient,
        _log = log;

  @override
  Future<void> register(String email, String password) async {
    try {
      await _restClient.unauth().post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
        },
      );
    } on RestClientException catch (e, s) {
      if (e.statusCode == 400 &&
          e.response.data['message'].contains('User already exists')) {
        _log.error(e.error, e, s);
        throw UserExistsException();
      }

      _log.error('Erro ao cadastrar usuário', e, s);
      throw Failure(message: 'Erro ao cadastrar usuário');
    }
  }

  @override
  Future<String> login(String login, String password) async {
    try {
      final result = await _restClient.unauth().post(
        '/auth/',
        data: {
          'login': login,
          'password': password,
          'social_login': false,
          'supplier_user': false,
        },
      );

      // Decodificar se result.data for String
      final data =
          result.data is String ? jsonDecode(result.data) : result.data;

      // Verificando o tipo e conteúdo de data
      if (data is Map) {
        if (data.containsKey('access_token') &&
            data['access_token'] is String) {
          final acToken = data['access_token'];
          return acToken;
        } else {
          _log.error(
            'Unexpected format or missing access_token in response: $data',
          );
          throw Failure(
            message: 'Erro ao realizar login, tente novamente mais tarde.',
          );
        }
      } else {
        _log.error('Unexpected response type: ${data.runtimeType}');
        throw Failure(
          message: 'Erro ao realizar login, tente novamente mais tarde.',
        );
      }
    } on RestClientException catch (e, s) {
      if (e.statusCode == 403) {
        throw Failure(
          message: 'Usuário inconsistente, entre em contato com o suporte!',
        );
      }
      _log.error('Error on try login', e, s);
      throw Failure(
        message: 'Erro ao realizar login, tente novamente mais tarde.',
      );
    }
  }

  @override
  Future<ConfirmLoginModel> confirmLogin() async {
    try {
      final deviceToken = await FirebaseMessaging.instance.getToken();

      final result = await _restClient.auth().patch(
        '/auth/confirm',
        data: {
          'ios_token': Platform.isIOS ? deviceToken : '',
          'android_token': Platform.isAndroid ? deviceToken : '',
        },
      );

      // Decodificar a resposta se for uma string JSON
      final data =
          result.data is String ? jsonDecode(result.data) : result.data;

      if (data is Map<String, dynamic>) {
        return ConfirmLoginModel.fromMap(data);
      } else {
        _log.error('Unexpected response type: ${data.runtimeType}');
        throw Failure(
          message: 'Erro no formato de resposta, tente novamente mais tarde.',
        );
      }
    } on RestClientException catch (e, s) {
      _log.error('Error on try confirm login', e, s);
      throw Failure(message: 'Erro ao confirmar login');
    }
  }

  @override
  Future<UserModel> getUserLogged() async {
    try {
      final result = await _restClient.get('/user/');

      // Decodificar a resposta se for uma string JSON
      final data =
          result.data is String ? jsonDecode(result.data) : result.data;

      if (data is Map<String, dynamic>) {
        return UserModel.fromMap(data);
      } else {
        _log.error('Unexpected response type: ${data.runtimeType}');
        throw Failure(
          message: 'Erro no formato de resposta, tente novamente mais tarde.',
        );
      }
    } on RestClientException catch (e, s) {
      _log.error('Error on getUserLogged', e, s);
      throw Failure(message: 'Erro ao obter dados do usuário');
    }
  }

  @override
  Future<String> loginSocial(SocialNetworkModel model) async {
    try {
      final result = await _restClient.unauth().post(
        '/auth/',
        data: {
          'login': model.email,
          'social_login': true,
          'avatar': model.avatar,
          'social_type': model.type,
          'social_key': model.id,
          'supplier_user': false,
        },
      );

      // Decodificar se result.data for String
      final data =
          result.data is String ? jsonDecode(result.data) : result.data;

      // Verificando o tipo e conteúdo de data
      if (data is Map) {
        if (data.containsKey('access_token') &&
            data['access_token'] is String) {
          final acToken = data['access_token'];
          return acToken;
        } else {
          _log.error(
            'Unexpected format or missing access_token in response: $data',
          );
          throw Failure(
            message: 'Erro ao realizar login, tente novamente mais tarde.',
          );
        }
      } else {
        _log.error('Unexpected response type: ${data.runtimeType}');
        throw Failure(
          message: 'Erro ao realizar login, tente novamente mais tarde.',
        );
      }
    } on RestClientException catch (e, s) {
      if (e.statusCode == 403) {
        throw Failure(
          message: 'Usuário inconsistente, entre em contato com o suporte!',
        );
      }
      _log.error('Error on try login', e, s);
      throw Failure(
        message: 'Erro ao realizar login, tente novamente mais tarde.',
      );
    }
  }
}
