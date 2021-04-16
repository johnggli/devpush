import 'dart:math';

import 'package:devpush/models/mission_model.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/services/database_service.dart';
import 'package:flutter/material.dart';

final DatabaseService databaseService = DatabaseService();

class DatabaseProvider extends ChangeNotifier {
  // private
  int _userId;
  UserModel _user;

  // getters
  UserModel get user {
    return _user;
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

  Future<void> updateMissions() async {
    await databaseService.updateUser(_userId, 'missions',
        _user.missions.map((mission) => mission.toJson()).toList());
  }

  Future<void> receiveSageReward() async {
    MissionModel sage = _user.missions[0];

    try {
      await addDevPoints(sage.reward);
      sage.reward = 0;
      await updateMissions();
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on receiveSageReward');
    }
  }

  Future<void> updateSage() async {
    List goals = [3, 5]; // Level
    List rewards = [30, 50]; // DevPoints

    MissionModel sage = _user.missions[0];

    if (_user.level == sage.currentGoal) {
      sage.reward += rewards[sage.level - 1];

      if (sage.currentGoal == goals[goals.length - 1]) {
        sage.isCompleted = true;
      } else {
        sage.level += 1;
        sage.currentGoal = goals[sage.level - 1];
      }

      try {
        await updateMissions();
        notifyListeners();
      } on Exception catch (_) {
        debugPrint('Error on updateSage');
      }
    }
  }

  Future<void> levelUp() async {
    int currentLevel = _user.level;
    int newlevel = currentLevel + 1;

    try {
      await databaseService.updateUser(_userId, 'level', newlevel);
      _user.level = newlevel;
      notifyListeners();
      await updateSage();
    } on Exception catch (_) {
      debugPrint('Error on levelUp');
    }
  }

  Future<void> addDevPoints(int amount) async {
    int currentDevPoints = _user.devPoints;

    int finalDevPoints = currentDevPoints + amount;

    try {
      await databaseService.updateUser(_userId, 'devPoints', finalDevPoints);
      _user.devPoints = finalDevPoints;
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on addDevPoints');
    }

    int currentLevel = _user.level;
    int devPointsToNextLevel = pow((currentLevel + 1) * 4, 2);

    if (finalDevPoints >= devPointsToNextLevel) {
      // finalDevPoints = finalDevPoints - devPointsToNextLevel;
      await levelUp();
    }
  }

  Future<void> initUser(int userId) async {
    Map<String, dynamic> databaseUser =
        await databaseService.getUserById(userId);

    if (databaseUser == null) {
      await databaseService.createUser(userId);
      databaseUser = await databaseService.getUserById(userId);
    }

    try {
      _user = UserModel.fromJson(databaseUser);
      _userId = userId;
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on initUser');
    }
  }
}
