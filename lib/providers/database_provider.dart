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

    await addDevPoints(devPoints);
    await addDevCoins(devCoins);
    await databaseService.resetMissionReward(_userId, missionId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> levelUp() async {
    int currentLevel = _user.level;
    int newlevel = currentLevel + 1;

    await databaseService.updateUser(_userId, 'level', newlevel);

    _user.level = newlevel;
    notifyListeners();

    await databaseService.updateMission(
      _userId,
      1,
      _user.level,
      [3, 5, 7],
      [30, 50, 70],
      [30, 50, 70],
    );
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
    } else {
      Map<String, dynamic> githubUser =
          await githubService.getGithubUserDetails(userId);

      if (databaseUser['login'] != githubUser['login']) {
        databaseUser['login'] = githubUser['login'];
        databaseService.updateUser(userId, 'login', githubUser['login']);
      }
      if (databaseUser['bio'] != githubUser['bio']) {
        databaseUser['bio'] = githubUser['bio'];
        databaseService.updateUser(userId, 'bio', githubUser['bio']);
      }
      if (databaseUser['following'] != githubUser['following']) {
        databaseUser['following'] = githubUser['following'];
        databaseService.updateUser(
            userId, 'following', githubUser['following']);
      }
    }

    _user = UserModel.fromJson(databaseUser);
    _userId = userId;
    notifyListeners();
  }

  Future<void> setLastLogin() async {
    var lastLogin = DateTime.parse(_user.lastLogin);
    var difference = DateTime.now().difference(lastLogin).inDays;

    if (difference > 0) {
      if (difference == 1) {
        _user.loginStreak += 1;
        notifyListeners();

        databaseService.updateUser(
          _userId,
          'loginStreak',
          _user.loginStreak,
        );
      } else {
        _user.loginStreak = 1;
        notifyListeners();

        databaseService.updateUser(
          _userId,
          'loginStreak',
          1,
        );
      }

      _user.totalLogin += 1;
      notifyListeners();

      databaseService.updateUser(
        _userId,
        'totalLogin',
        _user.totalLogin,
      );

      String now = DateTime.now().toString();
      var date = now.split(' ')[0]; // something like "2021-03-21"

      _user.lastLogin = date;
      notifyListeners();

      databaseService.updateUser(
        _userId,
        'lastLogin',
        date,
      );

      await databaseService.updateMission(
        _userId,
        2,
        _user.loginStreak,
        [3, 5, 7],
        [30, 50, 70],
        [30, 50, 70],
      );

      await databaseService.updateMission(
        _userId,
        8,
        _user.totalLogin,
        [3, 5, 7],
        [30, 50, 70],
        [30, 50, 70],
      );
    }
  }

  // Future<void> updateProviderUser() async {
  //   Map<String, dynamic> databaseUser =
  //       await databaseService.getUserById(_userId);
  //   try {
  //     _user = UserModel.fromJson(databaseUser);
  //     notifyListeners();
  //   } on Exception catch (_) {
  //     debugPrint('Error on updateProviderUser');
  //   }
  // }

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

  Future<QuerySnapshot> getRankUsers() async {
    return databaseService.getRankUsers();
  }

  Future<void> updateRank() async {
    await databaseService.updateRank();

    var databaseUser = await databaseService.getUserById(_userId);

    if (_user.rank != databaseUser['rank']) {
      _user.rank = databaseUser['rank'];
      notifyListeners();
    }
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

  Future<bool> getUserVisitCardById(String visitCardId) async {
    return await databaseService.getUserVisitCardById(_userId, visitCardId);
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

    await databaseService.updateUser(_userId, 'wins', newWinsValue);

    _user.wins = newWinsValue;
    notifyListeners();

    await databaseService.updateMission(
      _userId,
      3,
      _user.wins,
      [3, 5, 7],
      [30, 50, 70],
      [30, 50, 70],
    );
  }

  Future<void> setFollowing(bool isReload) async {
    if (isReload) {
      var githubUser = await githubService.getGithubUserDetails(_userId);

      if (_user.following != githubUser['following']) {
        _user.following = githubUser['following'];
        notifyListeners();

        await databaseService.updateUser(_userId, 'following', _user.following);
      }
    }

    await databaseService.updateMission(
      userId,
      4,
      _user.following,
      [3, 5, 7],
      [30, 50, 70],
      [30, 50, 70],
    );
  }

  Future<void> setCompletedMissions() async {
    var databaseUser = await databaseService.getUserById(_userId);

    if (_user.completedMissions != databaseUser['completedMissions']) {
      _user.completedMissions = databaseUser['completedMissions'];
      notifyListeners();
    }

    await databaseService.updateMission(
      _userId,
      5,
      _user.completedMissions,
      [3, 5, 7],
      [30, 50, 70],
      [30, 50, 70],
    );
  }

  Future<void> setTotalCreatedQuizzes() async {
    await databaseService.updateMission(
      _userId,
      6,
      _user.totalCreatedQuizzes,
      [3, 5, 7],
      [30, 50, 70],
      [30, 50, 70],
    );
  }

  Future<void> setTotalPostPoints() async {
    await databaseService.updateMission(
      _userId,
      7,
      _user.totalPostPoints,
      [3, 5, 7],
      [30, 50, 70],
      [30, 50, 70],
    );
  }

  Future<void> buyVisitCard(String visitCardId, int value) async {
    await databaseService.updateUser(
        _userId, 'devCoins', _user.devCoins - value);
    await databaseService.addVisitCardToUser(visitCardId, _userId);
    _user.devCoins = _user.devCoins - value;
    notifyListeners();
  }

  Future<void> setVisitCard(String visitCardImage) async {
    if (_user.visitCard != visitCardImage) {
      await databaseService.updateUser(_userId, 'visitCard', visitCardImage);
      _user.visitCard = visitCardImage;
      notifyListeners();
    }
  }

  Stream<QuerySnapshot> getVisitCards() {
    return databaseService.getVisitCards();
  }
}
