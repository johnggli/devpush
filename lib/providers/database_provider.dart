import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/core/app_colors.dart';
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

  // setters
  void setMedalNotification(bool value) {
    _medalNotification = value;
    notifyListeners();
  }

  void setWelcomeBonus(bool value) {
    _welcomeBonus = value;
    notifyListeners();
  }

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

  Stream<QuerySnapshot> getMedals(int userId) {
    return databaseService.getMedals(userId);
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
      _welcomeBonus = true;
      notifyListeners();
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

  Stream<DocumentSnapshot> getMedalById(int medalId) {
    return databaseService.getMedalById(medalId);
  }

  Stream<DocumentSnapshot> getUserVisitCardById(String visitCardId) {
    return databaseService.getUserVisitCardById(_userId, visitCardId);
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

  Future<bool> getUserLikedPostById(String postId) async {
    return await databaseService.getUserLikedPostById(_userId, postId);
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
      checkLoginMedals();
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
    String color,
    int codePoint,
    String label,
    String title,
    String date,
    String desc,
  ) async {
    try {
      await databaseService
          .addMedal(_userId, color, codePoint, label, title, date, desc)
          .then((_) {
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

  void checkLoginMedals() {
    List _loginMedals = [
      {
        'label': '02',
        'title': 'Bem-Vindo De Volta!',
        'desc': 'Abram as portas! Você fez login pela segunda vez no DevPush.'
      },
      {
        'label': '05',
        'title': 'Volte sempre!',
        'desc':
            'Isto não é uma ordem, claro. É a quinta vez que você entra no DevPush.'
      },
      {
        'label': '10',
        'title': 'Tapinha no ombro',
        'desc': 'E aí, tudo bem? É a décima vez que você entra aqui.'
      },
      {
        'label': '25',
        'title': 'Sofisticado',
        'desc':
            'Você adentrou estes salões respeitosos pela vigésima-quinta vez.'
      },
      {
        'label': '50',
        'title': 'Sei onde fica',
        'desc':
            'São cinquenta logins. Você não precisa mais de um mapa pra chegar aqui.'
      },
      {
        'label': '100',
        'title': 'São tantas memórias',
        'desc':
            'Você fez seu centésimo login aqui. Lembra da primeira vez que nos visitou?'
      },
      {
        'label': '200',
        'title': 'Senhor dos logins',
        'desc':
            'Ter feito login 200 vezes te torna um verdadeiro senhor destas terras.'
      },
    ];

    [2, 5, 10, 25, 50, 100, 200].asMap().forEach((index, value) {
      if (_user.totalLogin == value) {
        addMedal(
          AppColors.green.toString(),
          Icons.exit_to_app.codePoint,
          _loginMedals[index]['label'],
          _loginMedals[index]['title'],
          DateTime.now().toString(),
          _loginMedals[index]['desc'],
        );
      }
    });
  }

  void checkQuizMedals() {
    List _quizMedals = [
      {
        'label': '01',
        'title': 'Haja Quiz!',
        'desc': 'Você criou seu primeiro quiz!'
      },
      {
        'label': '05',
        'title': 'Cinco Quizzes',
        'desc': 'Cinco? Isso mesmo, você já criou cinco quizzes!'
      },
      {
        'label': '10',
        'title': 'Você é 10!',
        'desc': 'Já são dez quizzes criados por você.'
      },
      {
        'label': '25',
        'title': 'Veterano',
        'desc': 'Você já criou 25 quizzes! De onde tira esse conhecimento?'
      },
      {
        'label': '50',
        'title': 'Eu que fiz',
        'desc':
            'Você já criou 50 quizzes! Seu nome é bem conhecido na vizinhança.'
      },
      {
        'label': '100',
        'title': 'Reza a lenda',
        'desc':
            '"Quem chegar a criar 100 quizzes ganhará uma belíssima medalha", é o que dizem.'
      },
      {
        'label': '200',
        'title': 'De Cem em Cem...',
        'desc': 'Você já criou 200 quizzes! Isso que é empenho!'
      },
    ];

    [1, 5, 10, 25, 50, 100, 200].asMap().forEach((index, value) {
      if (_user.totalCreatedQuizzes == value) {
        addMedal(
          AppColors.purple.toString(),
          Icons.library_add.codePoint,
          _quizMedals[index]['label'],
          _quizMedals[index]['title'],
          DateTime.now().toString(),
          _quizMedals[index]['desc'],
        );
      }
    });
  }

  void checkPostMedals() {
    List _quizMedals = [
      {
        'label': '01',
        'title': 'Olá, Mundo!',
        'desc': 'Você fez sua primeira postagem na comunidade!'
      },
      {
        'label': '05',
        'title': 'Começando a ser notado',
        'desc':
            'Já são cinco postagens na comunidade. Você vai se enturmar rapidinho!'
      },
      {
        'label': '10',
        'title': 'Fazendo parte',
        'desc':
            'Já são dez mensagens postadas por você. Comemore com esta medalha!'
      },
      {
        'label': '25',
        'title': 'Por falar nisso',
        'desc': 'Já são 25 mensagens postadas por você na comunidade!'
      },
      {
        'label': '50',
        'title': 'Já vi você antes',
        'desc':
            'Você já criou cinquenta postagens na comunidade! Seu nome está ficando famoso.'
      },
      {
        'label': '100',
        'title': 'Capitão óbvio',
        'desc': '100 postagens na comunidade! Não são 98 nem 99, mas 100!'
      },
      {
        'label': '200',
        'title': 'Famoso',
        'desc':
            'Já são duzentas postagens na comunidade! Você espalha conhecimento por onde passa.'
      },
    ];

    [1, 5, 10, 25, 50, 100, 200].asMap().forEach((index, value) {
      if (_user.totalCreatedPosts == value) {
        addMedal(
          AppColors.pink.toString(),
          Icons.favorite.codePoint,
          _quizMedals[index]['label'],
          _quizMedals[index]['title'],
          DateTime.now().toString(),
          _quizMedals[index]['desc'],
        );
      }
    });
  }
}
