import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/services/database_service.dart';
import 'package:flutter/material.dart';

final DatabaseService databaseService = DatabaseService();

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

  Future<void> receiveLegendaryReward() async {
    _isLoading = true;
    notifyListeners();

    try {
      await databaseService.receiveLegendaryReward(_userId);
      await updateProviderUser();
    } on Exception catch (_) {
      debugPrint('Error on receiveLegendaryReward');
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
      await databaseService.updateLegendary(_userId);
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

  Stream<DocumentSnapshot> getLegendary(int userId) {
    return databaseService.getLegendary(userId);
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
}
