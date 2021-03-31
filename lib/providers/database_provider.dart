import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // private
  // int _userId;

  // getters
  // int get userId {
  //   return _userId;
  // }

  // functions
  //
  //
  //
  //
  //
  //
  // -> verifica se o usuario é novo ou não, caso seja novo, ele vai criar um
  // novo usuario la no firebase
  //
  //
  //
  //
  //
  //
  //
  // Future<void> initAction() async {
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
