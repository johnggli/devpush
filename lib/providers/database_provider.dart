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
  // Future<void> setUser(int userId) async {
  //   return databaseService.getUserById(userId);
  // }

  // Future<void> createUser(int userId) async {
  //   return databaseService.createUser(userId);
  // }

  // Future<void> getUsers() async {
  //   return databaseService.getUsers();
  // }

  // -> verifica se o usuario é novo ou não, caso seja novo, ele vai criar um
  // novo usuario la no firebase
  Future<void> initUser(int userId) async {
    Map<String, Object> databaseUser =
        await databaseService.getUserById(userId);

    if (databaseUser == null) {
      await databaseService.createUser(userId);
      databaseUser = await databaseService.getUserById(userId);
    }

    try {
      _currentUser = databaseUser;
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on initUser');
    }
  }
}
