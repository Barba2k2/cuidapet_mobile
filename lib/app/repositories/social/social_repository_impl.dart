import 'package:google_sign_in/google_sign_in.dart';

import '../../core/exceptions/failure.dart';
import '../../models/social_network_model.dart';
import './social_repository.dart';

class SocialRepositoryImpl implements SocialRepository {
  @override
  Future<SocialNetworkModel> facebookLogin() {
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
