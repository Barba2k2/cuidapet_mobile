import 'package:google_sign_in/google_sign_in.dart';

import '../../core/exceptions/failure.dart';
import '../../models/social_network_model.dart';
import './social_repository.dart';

class SocialRepositoryImpl implements SocialRepository {
  @override
  Future<SocialNetworkModel> facebookLogin() async {
    // final facebookAuth = FacebookAuth.instance;

    // final result = await facebookAuth.login();

    // switch (result.status) {
    //   case LoginStatus.success:
    //     final userData = await facebookAuth.getUserData();
    //     return SocialNetworkModel(
    //       id: userData['id'],
    //       name: userData['name'],
    //       email: userData['email'],
    //       type: 'Facebook',
    //       avatar: userData['picture']['data']['url'],
    //       accessToken: result.accessToken?.token ?? '',
    //     );
    //   case LoginStatus.cancelled:
    //     throw Failure(message: 'Login cancelado');
    //   case LoginStatus.failed:
    //   case LoginStatus.operationInProgress:
    //     throw Failure(message: result.message);
    // }

    throw UnimplementedError();
  }

  @override
  Future<SocialNetworkModel> googleLogin() async {
    final googleSignIn = GoogleSignIn();

    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }

    final googleUser = await googleSignIn.signIn();

    final googleAuth = await googleUser?.authentication;

    if (googleAuth != null && googleUser != null) {
      return SocialNetworkModel(
        id: googleAuth.idToken ?? '',
        name: googleUser.displayName ?? '',
        email: googleUser.email,
        type: 'Google',
        avatar: googleUser.photoUrl,
        accessToken: googleAuth.idToken ?? '',
      );
    } else {
      throw Failure(message: 'Erro ao realizar login com Google');
    }
  }
}
