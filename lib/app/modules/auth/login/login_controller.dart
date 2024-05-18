// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mobx/mobx.dart';

import '../../../core/exceptions/failure.dart';
import '../../../core/exceptions/user_not_exists_exception.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/ui/widgets/loader.dart';
import '../../../core/ui/widgets/messages.dart';
import '../../../services/user/user_service.dart';

part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final UserService _userService;
  final AppLogger _log;

  _LoginControllerBase({
    required UserService userService,
    required AppLogger log,
  })  : _userService = userService,
        _log = log;

  Future<void> login(String login, String password) async {
    try {
      Loader.show();
      await _userService.login(login, password);
      Loader.hide();
    } on Failure catch (e, s) {
      final errorMessage = e.message ?? 'Erro ao realizar login';
      _log.error(errorMessage, e, s);
      Loader.hide();
      Messages.alert(errorMessage);
    }on UserNotExistsException {
      _log.error('User not find');
      Loader.hide();
      Messages.alert('Usuário não cadastrado');
    }
  }
}
