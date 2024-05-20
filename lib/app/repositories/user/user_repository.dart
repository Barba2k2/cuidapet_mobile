import '../../models/confirm_login_model.dart';
import '../../models/social_network_model.dart';
import '../../models/user_model.dart';

abstract class UserRepository {
  Future<void> register(String email, String password);
  Future<String> login(String email, String password);
  Future<ConfirmLoginModel> confirmLogin();
  Future<UserModel> getUserLogged();
  Future<String> loginSocial(SocialNetworkModel model);
}
