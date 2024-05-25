import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../core/exceptions/failure.dart';
import '../../../core/exceptions/user_exists_exception.dart';
import '../../../core/exceptions/user_not_exists_exception.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/ui/widgets/loader.dart';
import '../../../core/ui/widgets/messages.dart';
import '../../../models/social_login_type.dart';
import '../../../services/user/user_service.dart';

part 'login_controller.g.dart';

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  final UserService _userService;
  final AppLogger _log;

  LoginControllerBase({
    required UserService userService,
    required AppLogger log,
  })  : _userService = userService,
        _log = log;

  Future<void> login(String login, String password) async {
    try {
      Loader.show();
      await _userService.login(login, password);
      Loader.hide();
      Modular.to.navigate('/auth/');
    } on Failure catch (e, s) {
      final errorMessage = e.message ?? 'Erro ao realizar login';
      _log.error(errorMessage, e, s);
      Loader.hide();
      Messages.alert(errorMessage);
    } on UserNotExistsException {
      _log.error('User not find');
      Loader.hide();
      Messages.alert('Usuário não cadastrado');
    } on UserExistsException {
      _log.error('User already exists');
      Loader.hide();
      Messages.alert('Usuário já registrado, faça login com suas credenciais.');
    }
  }

  Future<void> socialLogin(SocialLoginType socialLoginType) async {
    try {
      Loader.show();
      await _userService.socialLogin(socialLoginType);
      Loader.hide();
      Modular.to.navigate('/auth/');
    } on Failure catch (e, s) {
      _log.error('Error on social login', e, s);
      Loader.hide();
      Messages.alert(
        e.message ?? 'Erro ao realizar login social',
      );
    }
  }
}
