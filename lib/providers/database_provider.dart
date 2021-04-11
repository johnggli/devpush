import 'dart:math';

// import 'package:devpush/models/mission_model.dart';
import 'package:devpush/services/database_service.dart';
import 'package:flutter/material.dart';

final DatabaseService databaseService = DatabaseService();

class DatabaseProvider extends ChangeNotifier {
  // private
  int _currentUserId;
  Map<String, Object> _currentUser;
  List<Map<String, Object>> _missions = [
    {
      'title': 'Sábio',
      'goals': [3, 5, 7, 10, 15],
      'completed': false
    }
    // Mission(1, 'Sábio', description, level, current, goal, completed)
  ];

  // getters
  Map<String, Object> get currentUser {
    return _currentUser;
  }

  List<Map<String, Object>> get missions {
    return _missions;
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

  Future<void> levelUp() async {
    int currentLevel = _currentUser['level'];
    int newlevel = currentLevel + 1;

    try {
      await databaseService.updateUser(_currentUserId, 'level', newlevel);
      _currentUser['level'] = newlevel;
      notifyListeners();
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
