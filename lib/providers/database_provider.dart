import 'package:devpush/services/database_service.dart';
import 'package:flutter/material.dart';

final DatabaseService databaseService = DatabaseService();

class DatabaseProvider extends ChangeNotifier {
  // private
  Map<String, Object> _currentUser;

  // getters
  Map<String, Object> get currentUser {
    return _currentUser;
  }

  // functions
  Future<void> setUser(int userId) async {
    return databaseService.getUser(userId);
  }

  // -> verifica se o usuario é novo ou não, caso seja novo, ele vai criar um
  // novo usuario la no firebase
  // Future<void> initUser() async {
  //   final String storedRefreshToken =
  //       await storageService.readStorageData('refresh_token');
  //   if (storedRefreshToken == null) return;

  //   _isBusy = true;
  //   notifyListeners();

  //   try {
  //     final TokenResponse response =
  //         await authService.getTokenResponse(storedRefreshToken);

  //     final Map<String, Object> profile =
  //         await authService.getUserDetails(response.accessToken);

  //     // await storageService.writeStorageData(
  //     //     'refresh_token', response.refreshToken);

  //     var sub = profile['sub']; // github|43749971
  //     _userId = int.parse(sub.toString().split('|')[1]); // 43749971
  //     _isBusy = false;
  //     _isLoggedIn = true;
  //     notifyListeners();
  //   } on Exception catch (e, s) {
  //     debugPrint('error on refresh token: $e - stack: $s');
  //     // await logoutAction();
  //   }
  // }
}
