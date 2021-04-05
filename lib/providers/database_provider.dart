import 'package:devpush/services/database_service.dart';
import 'package:flutter/material.dart';

final DatabaseService databaseService = DatabaseService();

class DatabaseProvider extends ChangeNotifier {
  // private
  int _currentUserId;
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
  //

  // usuario tem 30 pontos
  var points = [50, 250, 500, 750, 1000];

  void levelUp() {}

  Future<void> addDevPoints(int amount) async {
    int currentDevPoints = _currentUser['devPoints'];

    int finalDevPoints = currentDevPoints + amount;

    try {
      await databaseService.updateDevPoints(_currentUserId, finalDevPoints);
      _currentUser['devPoints'] = finalDevPoints;
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on addDevPoints');
    }
    // ver como atualizar somente um atributo do usuario no firebase
    //
    // let finalExperience = currentExperience + amount;

    // if (finalExperience >= experienceToNextLevel) {
    //   finalExperience = finalExperience - experienceToNextLevel;
    //   levelUp();
    // }
  }

  void nomedamissao() {}

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
      _currentUserId = userId;
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on initUser');
    }
  }
}
