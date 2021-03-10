import 'package:flutter/widgets.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:devpush/services/auth_service.dart';

final AuthService authService = AuthService();
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

class AuthBloc extends ChangeNotifier {
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String name;
  String picture;

  Future<void> loginAction() async {
    isBusy = true;
    errorMessage = '';
    notifyListeners();

    try {
      final AuthorizationTokenResponse result =
          await authService.getAuthTokenResponse();

      final Map<String, Object> idToken =
          authService.parseIdToken(result.idToken);
      final Map<String, Object> profile =
          await authService.getUserDetails(result.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      isBusy = false;
      isLoggedIn = true;
      name = idToken['name'];
      picture = profile['picture'];
      notifyListeners();
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      isBusy = false;
      isLoggedIn = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    isLoggedIn = false;
    isBusy = false;
    notifyListeners();
  }

  Future<void> initAction() async {
    final String storedRefreshToken =
        await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    isBusy = true;
    notifyListeners();

    try {
      final TokenResponse response =
          await authService.getTokenResponse(storedRefreshToken);

      final Map<String, Object> idToken =
          authService.parseIdToken(response.idToken);
      final Map<String, Object> profile =
          await authService.getUserDetails(response.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: response.refreshToken);

      isBusy = false;
      isLoggedIn = true;
      name = idToken['name'];
      picture = profile['picture'];
      notifyListeners();
    } on Exception catch (e, s) {
      debugPrint('error on refresh token: $e - stack: $s');
      await logoutAction();
    }
  }
}
