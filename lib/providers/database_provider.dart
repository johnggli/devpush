import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/services/database_service.dart';
import 'package:devpush/services/github_service.dart';
import 'package:flutter/material.dart';

final DatabaseService databaseService = DatabaseService();
final GithubService githubService = GithubService();

class DatabaseProvider extends ChangeNotifier {
  // private
  int _userId;
  UserModel _user;
  int _currentPage = 1;
  int _qtdAnswerRight = 0;
  bool _isLoading = false;
  bool _haveReward = false;

  // getters
  int get userId {
    return _userId;
  }

  UserModel get user {
    return _user;
  }

  int get currentPage {
    print(
        'PASSOU PELO CURRENT PAGE NO DATABASE PROVIDER, VALOR ATUAL: $_currentPage');
    return _currentPage;
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get haveReward {
    return _haveReward;
  }

  set haveReward(bool value) {
    _haveReward = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setCurrentPage(int value) {
    _currentPage = value;
    print(
        'PASSOU PELO SET CURRENT PAGE NO DATABASE PROVIDER, NOVO VALOR: $_currentPage');
    notifyListeners();
  }

  int get qtdAnswerRight {
    return _qtdAnswerRight;
  }

  void setqtdAnswerRight(int value) {
    _qtdAnswerRight = value;
    notifyListeners();
  }

  void addAnswerRight() {
    _qtdAnswerRight++;
    notifyListeners();
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

  Future<void> receiveMissionReward(int missionId) async {
    _isLoading = true;
    notifyListeners();

    var mission = await databaseService.getMissionDataById(_userId, missionId);

    int devPoints = mission.data()['devPointsRewards'];
    int devCoins = mission.data()['devCoinsRewards'];

    try {
      await addDevPoints(devPoints);
      await addDevCoins(devCoins);
      await databaseService.resetMissionReward(_userId, missionId);
      await updateProviderUser();
    } on Exception catch (_) {
      debugPrint('Error on receiveMissionReward');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> levelUp() async {
    int currentLevel = _user.level;
    int newlevel = currentLevel + 1;

    try {
      await databaseService.updateUser(_userId, 'level', newlevel);
      _user.level = newlevel;
      await databaseService.updateMission(
        _userId,
        1,
        'level',
        [3, 5, 7],
        [30, 50, 70],
        [30, 50, 70],
      );
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on levelUp');
    }
  }

  Future<void> addQuizData(Map quizData, String quizId) async {
    try {
      await databaseService.addQuizData(quizData, quizId);
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on addQuiz');
    }
  }

  Future<void> addQuizQuestion(
      Map questionData, int numberOfQuestions, String quizId) async {
    try {
      await databaseService.addQuizQuestion(questionData, quizId);
      await databaseService.updateQuiz(
          quizId, 'numberOfQuestions', numberOfQuestions);
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on addQuizQuestion');
    }
  }

  Stream<QuerySnapshot> getAllQuizzes() {
    return databaseService.getAllQuizzes();
  }

  Stream<QuerySnapshot> getQuestions(String quizId) {
    return databaseService.getQuestions(quizId);
  }

  Future<void> addDevPoints(int amount) async {
    _isLoading = true;
    notifyListeners();

    int currentDevPoints = _user.devPoints;

    int devPoints = currentDevPoints + amount;

    int currentLevel = _user.level;
    int devPointsToNextLevel = pow((currentLevel + 1) * 4, 2);

    int finalValue = 0;
    int restDevPoints = 0;

    if (devPoints >= devPointsToNextLevel) {
      await levelUp();
      restDevPoints = devPoints - devPointsToNextLevel;
      finalValue = devPointsToNextLevel;
    } else {
      finalValue = devPoints;
    }

    try {
      await databaseService.updateUser(_userId, 'devPoints', finalValue);
      _user.devPoints = finalValue;
      notifyListeners();
      if (restDevPoints > 0) {
        await addDevPoints(restDevPoints);
      }
    } on Exception catch (_) {
      debugPrint('Error on addDevPoints');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addDevCoins(int amount) async {
    _isLoading = true;
    notifyListeners();

    int currentDevCoins = _user.devCoins;

    int finalDevCoins = currentDevCoins + amount;

    try {
      await databaseService.updateUser(_userId, 'devCoins', finalDevCoins);
      _user.devCoins = finalDevCoins;
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on addDevCoins');
    }

    _isLoading = false;
    notifyListeners();
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

  Future<void> setLastLogin(int userId) async {
    Map<String, dynamic> databaseUser =
        await databaseService.getUserById(userId);

    var lastLogin = DateTime.parse(databaseUser['lastLogin']);
    print('lastLogin: $lastLogin');

    var difference = DateTime.now().difference(lastLogin).inDays;
    print('difference: $difference');

    if (difference > 0) {
      if (difference == 1) {
        databaseService.updateUser(
          userId,
          'loginStreak',
          databaseUser['loginStreak'] + 1,
        );
      } else {
        databaseService.updateUser(
          userId,
          'loginStreak',
          0,
        );
      }

      databaseService.updateUser(
        userId,
        'totalLogin',
        databaseUser['totalLogin'] + 1,
      );

      String now = DateTime.now().toString();
      var date = now.split(' ')[0]; // something like "2021-03-21"
      databaseService.updateUser(
        userId,
        'lastLogin',
        date,
      );

      await databaseService.updateMission(
        _userId,
        2,
        'loginStreak',
        [3, 5, 7],
        [30, 50, 70],
        [30, 50, 70],
      );

      await databaseService.updateMission(
        _userId,
        8,
        'totalLogin',
        [3, 5, 7],
        [30, 50, 70],
        [30, 50, 70],
      );

      await updateProviderUser();
    }
  }

  Future<void> updateProviderUser() async {
    Map<String, dynamic> databaseUser =
        await databaseService.getUserById(_userId);
    try {
      _user = UserModel.fromJson(databaseUser);
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on updateProviderUser');
    }
  }

  Future<UserModel> getUserModelById(int userId) async {
    Map<String, dynamic> databaseUser =
        await databaseService.getUserById(userId);
    return UserModel.fromJson(databaseUser);
  }

  Future<void> receiveReward() async {
    try {
      await addDevPoints(30);
      await addDevCoins(10);
      // await updateMissions();
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on receiveReward');
    }
  }

  Future<void> addUserSolvedQuiz(Map quizData, String quizId) async {
    try {
      await databaseService.addUserSolvedQuiz(_userId, quizData, quizId);
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on addUserSolvedQuiz');
    }
  }

  Future<void> sethaveReward(String quizId) async {
    // _isLoading = true;
    // notifyListeners();

    try {
      _haveReward =
          await databaseService.getUserSolvedQuizById(_userId, quizId);
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on sethaveReward');
    }

    // _isLoading = false;
    // notifyListeners();
  }

  Stream<DocumentSnapshot> getQuizById(String quizId) {
    return databaseService.getQuizById(quizId);
  }

  Stream<DocumentSnapshot> getMissionById(int userId, int missionId) {
    return databaseService.getMissionById(userId, missionId);
  }

  Stream<QuerySnapshot> getHighlighted() {
    return databaseService.getHighlighted();
  }

  Stream<QuerySnapshot> getVideos() {
    return databaseService.getVideos();
  }

  Future<void> addVideoSuggestion(String videoUrl) async {
    try {
      await databaseService.addVideoSuggestion(videoUrl);
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on addVideoSuggestion');
    }
  }

  Stream<QuerySnapshot> getPosts() {
    return databaseService.getPosts();
  }

  Future<void> addPost(Map postData, String postId) async {
    try {
      await databaseService.addPost(postData, postId);
    } on Exception catch (_) {
      debugPrint('Error on addPost');
    }
  }

  Future<void> likePost(String postId, int creatorUserId) async {
    try {
      await databaseService.likePost(postId, _userId, creatorUserId);
    } on Exception catch (_) {
      debugPrint('Error on likePost');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await databaseService.deletePost(postId);
    } on Exception catch (_) {
      debugPrint('Error on deletePost');
    }
  }

  Future<bool> getUserLikedPostById(String postId) async {
    return await databaseService.getUserLikedPostById(_userId, postId);
  }

  Future<void> reportPost(String postId, String reason) async {
    try {
      await databaseService.reportPost(postId, _userId, reason);
    } on Exception catch (_) {
      debugPrint('Error on reportPost');
    }
  }

  Future<void> addWin() async {
    int currentWins = _user.wins;
    int newWinsValue = currentWins + 1;

    try {
      await databaseService.updateUser(_userId, 'wins', newWinsValue);
      _user.wins = newWinsValue;
      await databaseService.updateMission(
        _userId,
        3,
        'wins',
        [3, 5, 7],
        [30, 50, 70],
        [30, 50, 70],
      );
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on addWin');
    }
  }

  Future<void> setFollowing(int userId) async {
    var _githubUser = await githubService.getGithubUserDetails(userId);

    int currentFollowing = _githubUser['following'];

    try {
      await databaseService.updateUser(_userId, 'following', currentFollowing);
      _user.following = currentFollowing;
      await databaseService.updateMission(
        userId,
        4,
        'following',
        [3, 5, 7],
        [30, 50, 70],
        [30, 50, 70],
      );
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on setFollowing');
    }

    await updateProviderUser();
  }

  Future<void> setCompletedMissions(int userId) async {
    try {
      await databaseService.updateMission(
        _userId,
        5,
        'completedMissions',
        [3, 5, 7],
        [30, 50, 70],
        [30, 50, 70],
      );
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on setCompletedMissions');
    }
  }

  Future<void> setTotalCreatedQuizzes(int userId) async {
    try {
      await databaseService.updateMission(
        _userId,
        6,
        'totalCreatedQuizzes',
        [3, 5, 7],
        [30, 50, 70],
        [30, 50, 70],
      );
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on setTotalCreatedQuizzes');
    }
  }

  Future<void> setTotalPostPoints(int userId) async {
    try {
      await databaseService.updateMission(
        _userId,
        7,
        'totalPostPoints',
        [3, 5, 7],
        [30, 50, 70],
        [30, 50, 70],
      );
      notifyListeners();
    } on Exception catch (_) {
      debugPrint('Error on setTotalPostPoints');
    }
  }
}
