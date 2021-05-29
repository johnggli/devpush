import 'package:flutter/widgets.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:devpush/services/auth_service.dart';
import 'package:devpush/services/storage_service.dart';

final AuthService authService = AuthService();
final StorageService storageService = StorageService();

class AuthProvider extends ChangeNotifier {
  // private
  bool _isBusy = true;
  bool _isLoggedIn = false;
  String _errorMessage;

  int _userId;

  // getters
  bool get isBusy {
    return _isBusy;
  }

  bool get isLoggedIn {
    return _isLoggedIn;
  }

  String get errorMessage {
    return _errorMessage;
  }

  int get userId {
    return _userId;
  }

  // functions
  Future<void> loginAction() async {
    _isBusy = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final AuthorizationTokenResponse result =
          await authService.getAuthTokenResponse();

      // final Map<String, Object> idToken =
      //     authService.parseIdToken(result.idToken);
      final Map<String, Object> profile =
          await authService.getUserDetails(result.accessToken);

      await storageService.writeStorageData(
          'refresh_token', result.refreshToken);

      var sub = profile['sub']; // github|43749971
      _userId = int.parse(sub.toString().split('|')[1]); // 43749971
      _isBusy = false;
      _isLoggedIn = true;
      // _name = idToken['name'];
      // _picture = profile['picture'];
      // _user = UserModel.fromJson(user);
      notifyListeners();
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      _isBusy = false;
      _isLoggedIn = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> logoutAction() async {
    await storageService.deleteStorageData('refresh_token');
    _isLoggedIn = false;
    _isBusy = false;
    notifyListeners();
  }

  Future<void> initAction() async {
    final String storedRefreshToken =
        await storageService.readStorageData('refresh_token');
    if (storedRefreshToken == null) {
      _isBusy = false;
      notifyListeners();
      return;
    }

    // _isBusy = true;
    // notifyListeners();

    try {
      final TokenResponse response =
          await authService.getTokenResponse(storedRefreshToken);

      final Map<String, dynamic> profile =
          await authService.getUserDetails(response.accessToken);

      // await storageService.writeStorageData(
      //     'refresh_token', response.refreshToken);

      var sub = profile['sub']; // github|43749971
      _userId = int.parse(sub.split('|')[1]); // 43749971
      _isBusy = false;
      _isLoggedIn = true;
      notifyListeners();
    } on Exception catch (e, s) {
      debugPrint('error on refresh token: $e - stack: $s');
      // await logoutAction();
    }
  }
}
