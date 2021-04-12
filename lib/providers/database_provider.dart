import 'dart:math';

// import 'package:devpush/models/mission_model.dart';
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

  Future<void> updateSage() async {
    List goals = [3, 5, 7, 10, 15];
    Map<String, Object> sage = (_currentUser['missions'] as List)[0];

    if ((_currentUser['level'] as int) >= sage['currentGoal']) {
      try {
        sage['level'] = (sage['level'] as int) + 1;
        sage['currentGoal'] = goals[(sage['level'] as int) - 1];
        await databaseService.updateUser(
            _currentUserId, 'missions', _currentUser['missions']);
        notifyListeners();
      } on Exception catch (_) {
        debugPrint('Error on updateSage');
      }
    }
  }

  Future<void> levelUp() async {
    int currentLevel = _currentUser['level'];
    int newlevel = currentLevel + 1;

    try {
      await databaseService.updateUser(_currentUserId, 'level', newlevel);
      _currentUser['level'] = newlevel;
      notifyListeners();
      await updateSage();
    } on Exception catch (_) {
      debugPrint('Error on levelUp');
    }
  }

  Future<void> addDevPoints(int amount) async {
    int currentDevPoints = _currentUser['devPoints'];

    int finalDevPoints = currentDevPoints + amount;

    try {
      await databaseService.updateUser(
          _currentUserId, 'devPoints', finalDevPoints);
      _currentUser['devPoints'] = finalDevPoints;
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on addDevPoints');
    }

    int currentLevel = _currentUser['level'];
    int devPointsToNextLevel = pow((currentLevel + 1) * 4, 2);

    if (finalDevPoints >= devPointsToNextLevel) {
      // finalDevPoints = finalDevPoints - devPointsToNextLevel;
      await levelUp();
    }
  }

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
