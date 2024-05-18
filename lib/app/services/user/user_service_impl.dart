import 'package:firebase_auth/firebase_auth.dart';

import '../../core/exceptions/failure.dart';
import '../../core/exceptions/user_exists_exception.dart';
import '../../core/logger/app_logger.dart';
import '../../repositories/user/user_repository.dart';
import './user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final AppLogger _log;

  UserServiceImpl({
    required UserRepository userRepository,
    required AppLogger log,
  })  : _userRepository = userRepository,
        _log = log;

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
}
