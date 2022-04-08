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
  bool _isLoading = false;
  bool _haveReward = false;
  bool _medalNotification = false;
  bool _welcomeBonus = false;
  int _haveRated = 0;
  int _currentPage = 1;
  int _qtdAnswerRight = 0;

  // getters
  int get userId {
    return _userId;
  }

  UserModel get user {
    return _user;
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get haveReward {
    return _haveReward;
  }

  bool get medalNotification {
    return _medalNotification;
  }

  bool get welcomeBonus {
    return _welcomeBonus;
  }

  int get haveRated {
    return _haveRated;
  }

  int get currentPage {
    return _currentPage;
  }

  int get qtdAnswerRight {
    return _qtdAnswerRight;
  }

  // setters
  void setMedalNotification(bool value) {
    _medalNotification = value;
    notifyListeners();
  }

  void setWelcomeBonus(bool value) {
    _welcomeBonus = value;
    notifyListeners();
  }

  void setCurrentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  void setQtdAnswerRight(int value) {
    _qtdAnswerRight = value;
    notifyListeners();
  }

  void incrementQtdAnswerRight() {
    _qtdAnswerRight++;
    notifyListeners();
  }

  // devCoins
  // final _userDevCoinsNotifier = ValueNotifier<int>(0);
  // ValueNotifier<int> get userDevCoins => _userDevCoinsNotifier;
  // void updateUserDevCoins() {
  //   _userDevCoinsNotifier.value = _user.devCoins;
  // }

  // functions
  Future<List> receiveMissionReward(int missionId) async {
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

    return [devPoints, devCoins];
  }

  Future<void> addQuizQuestion(Map questionData, String quizId) async {
    await databaseService.addQuizQuestion(questionData, quizId);
  }

  Stream<QuerySnapshot> getAllQuizzes() {
    return databaseService.getAllQuizzes();
  }

  Stream<QuerySnapshot> getQuestions(String quizId) {
    return databaseService.getQuestions(quizId);
  }

  Stream<QuerySnapshot> getUserMedals(int userId) {
    return databaseService.getUserMedals(userId);
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
      // _welcomeBonus = true;
      // notifyListeners();
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
    }

    _user = UserModel.fromJson(databaseUser);
    _userId = userId;
    notifyListeners();
  }

  Future<UserModel> getUserModelById(int userId) async {
    Map<String, dynamic> databaseUser =
        await databaseService.getUserById(userId);
    return UserModel.fromJson(databaseUser);
  }

  Future<void> receiveReward() async {
    await addDevPoints(30);
    await addDevCoins(10);
  }

  Future<void> addUserSolvedQuiz(Map quizData, String quizId) async {
    await databaseService.addUserSolvedQuiz(_userId, quizData, quizId);
  }

  Future<void> sethaveReward(String quizId) async {
    _haveReward = await databaseService.getUserSolvedQuizById(_userId, quizId);
    notifyListeners();
  }

  Future<void> sethaveRated(String quizId) async {
    _haveRated = await databaseService.getUserRatedQuizById(_userId, quizId);
    notifyListeners();
  }

  Stream<DocumentSnapshot> getQuizById(String quizId) {
    return databaseService.getQuizById(quizId);
  }

  Stream<DocumentSnapshot> getMissionById(int userId, int missionId) {
    return databaseService.getMissionById(userId, missionId);
  }

  Stream<DocumentSnapshot> getMedalById(String kind, int medalId) {
    return databaseService.getMedalById(kind, medalId);
  }

  Stream<DocumentSnapshot> getUserVisitCardById(String visitCardId) {
    return databaseService.getUserVisitCardById(_userId, visitCardId);
  }

  Stream<DocumentSnapshot> getUserLikedPostById(String postId) {
    return databaseService.getUserLikedPostById(_userId, postId);
  }

  Stream<QuerySnapshot> getHighlighted() {
    return databaseService.getHighlighted();
  }

  Stream<QuerySnapshot> getVideos() {
    return databaseService.getVideos();
  }

  Future<void> addVideoSuggestion(String videoUrl) async {
    await databaseService.addVideoSuggestion(videoUrl);
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
    await databaseService.addPost(postData, postId).then((_) async {
      _user.totalCreatedPosts += 1;
      notifyListeners();

      await databaseService
          .updateUser(_userId, 'totalCreatedPosts', _user.totalCreatedPosts)
          .then((value) => checkPostMedals());
    });
  }

  Future<void> likePost(String postId, int creatorUserId) async {
    await databaseService.likePost(postId, _userId, creatorUserId);
  }

  Future<void> deletePost(String postId) async {
    await databaseService.deletePost(postId);
  }

  Future<void> deleteQuiz(String quizId) async {
    await databaseService.deleteQuiz(quizId);
  }

  Future<void> reportPost(String postId, String reason) async {
    await databaseService.reportPost(postId, _userId, reason);
  }

  Future<void> reportQuiz(String quizId, String reason) async {
    await databaseService.reportQuiz(quizId, _userId, reason);
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

  // -------------------------------- MISSIONS --------------------------------

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
      await checkLoginMedals();
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

  Future<void> addRatedQuiz(String quizId, int amount) async {
    await databaseService.addRatedQuiz(_userId, quizId, amount);

    _user.totalRatedQuizzes += 1;
    _haveRated = amount;
    notifyListeners();

    await databaseService.updateMission(
      _userId,
      4,
      _user.totalRatedQuizzes,
      [3, 5, 7],
      [30, 50, 70],
      [30, 50, 70],
    );
  }

  Future<void> refreshMissions() async {
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

    if (_user.totalPostPoints != databaseUser['totalPostPoints']) {
      _user.totalPostPoints = databaseUser['totalPostPoints'];
      notifyListeners();
    }

    await databaseService.updateMission(
      _userId,
      7,
      _user.totalPostPoints,
      [30, 50, 70],
      [30, 50, 70],
      [30, 50, 70],
    );

    if (_user.totalMedals != databaseUser['totalMedals']) {
      _user.totalMedals = databaseUser['totalMedals'];
      notifyListeners();
    }

    await databaseService.updateMission(
      _userId,
      8,
      _user.totalMedals,
      [3, 5, 7],
      [30, 50, 70],
      [30, 50, 70],
    );
  }

  Future<void> addMedal(
    String kind,
    int medalId,
    String date,
  ) async {
    try {
      await databaseService.addMedal(_userId, kind, medalId, date).then((_) {
        _medalNotification = true;
        notifyListeners();
      });
    } on Exception catch (_) {
      debugPrint('Error on incrementTotalMedals');
    }
  }

  Future<void> addQuizData(Map quizData, String quizId) async {
    await databaseService.addQuizData(quizData, quizId);

    _user.totalCreatedQuizzes += 1;
    notifyListeners();

    await databaseService.updateMission(
      _userId,
      6,
      _user.totalCreatedQuizzes,
      [3, 5, 7],
      [30, 50, 70],
      [30, 50, 70],
    );

    checkQuizMedals();
  }

  Future<void> checkLoginMedals() async {
    await databaseService.getMedalsIdsByKind('loginMedals').then((medalIds) {
      medalIds.asMap().forEach((index, medalId) {
        if (_user.totalLogin == medalId) {
          addMedal(
            'loginMedals',
            medalId,
            DateTime.now().toString(),
          );
        }
      });
    });
  }

  Future<void> checkQuizMedals() async {
    await databaseService.getMedalsIdsByKind('quizMedals').then((medalIds) {
      medalIds.asMap().forEach((index, medalId) {
        if (_user.totalCreatedQuizzes == medalId) {
          addMedal(
            'quizMedals',
            medalId,
            DateTime.now().toString(),
          );
        }
      });
    });
  }

  Future<void> checkPostMedals() async {
    await databaseService.getMedalsIdsByKind('postMedals').then((medalIds) {
      medalIds.asMap().forEach((index, medalId) {
        if (_user.totalCreatedPosts == medalId) {
          addMedal(
            'postMedals',
            medalId,
            DateTime.now().toString(),
          );
        }
      });
    });
  }
}
