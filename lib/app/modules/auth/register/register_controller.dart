import 'package:mobx/mobx.dart';

import '../../../core/exceptions/user_exists_exception.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/ui/widgets/loader.dart';
import '../../../core/ui/widgets/messages.dart';
import '../../../services/user/user_service.dart';

part 'register_controller.g.dart';

class RegisterController = RegisterControllerBase with _$RegisterController;

abstract class RegisterControllerBase with Store {
  final UserService _userService;
  final AppLogger _log;

  RegisterControllerBase({
    required UserService userService,
    required AppLogger log,
  })  : _userService = userService,
        _log = log;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      Loader.show();
      await _userService.register(email, password);
      Messages.info('Enviamos um email de confirmação para $email');
      Loader.hide();
    } on UserExistsException {
      Loader.hide();
      Messages.alert('Email already in use, please try another one');
    } catch (e, s) {
      _log.error('Error on registering user', e, s);
      Loader.hide();
      Messages.alert('Error on registering user');
    }
  }
}
