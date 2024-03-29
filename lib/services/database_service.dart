import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/services/github_service.dart';

final GithubService githubService = GithubService();

class DatabaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference quizzes =
      FirebaseFirestore.instance.collection('quizzes');
  CollectionReference highlighted =
      FirebaseFirestore.instance.collection('highlighted');
  CollectionReference videos = FirebaseFirestore.instance.collection('videos');
  CollectionReference videoSuggestions =
      FirebaseFirestore.instance.collection('videoSuggestions');
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference postsReports =
      FirebaseFirestore.instance.collection('postsReports');
  CollectionReference quizzesReports =
      FirebaseFirestore.instance.collection('quizzesReports');
  CollectionReference visitCards =
      FirebaseFirestore.instance.collection('visitCards');
  CollectionReference medals = FirebaseFirestore.instance.collection('medals');

  Future<Map<String, dynamic>> getUserById(int userId) async {
    Map<String, dynamic> result;

    await users.doc('$userId').get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        result = documentSnapshot.data();
      } else {
        result = null;
      }
    });
    return result;
  }

  Future createUser(int userId) async {
    String now = DateTime.now().toString();
    String lastLogin = now.split(' ')[0];

    var githubUser = await githubService.getGithubUserDetails(userId);

    await users.doc('$userId').set({
      'id': githubUser['id'],
      'login': githubUser['login'],
      'avatarUrl': githubUser['avatar_url'],
      'bio': githubUser['bio'],
      'level': 1,
      'devPoints': 50,
      'devCoins': 10,
      'lastLogin': lastLogin,
      'totalLogin': 1,
      'loginStreak': 1,
      'wins': 0,
      'completedMissions': 0,
      'totalCreatedQuizzes': 0,
      'totalCreatedPosts': 0,
      'totalPostPoints': 0,
      'rank': 0,
      'visitCard': '',
      'totalRatedQuizzes': 0,
      'totalMedals': 0,
    }).then((value) => initMissionsOfUser(userId));
  }

  Future<void> initMissionsOfUser(int userId) async {
    // Lendário
    await users.doc('$userId').collection('missions').doc('1').set({
      'level': 1,
      'currentGoal': 3, // Alcance o Level 3.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // Em Chamas!
    await users.doc('$userId').collection('missions').doc('2').set({
      'level': 1,
      'currentGoal': 3, // Entre no aplicativo por 3 dias seguidos.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // Invencível
    await users.doc('$userId').collection('missions').doc('3').set({
      'level': 1,
      'currentGoal': 3, // Complete 3 quizzes sem errar nada.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // Crítico
    await users.doc('$userId').collection('missions').doc('4').set({
      'level': 1,
      'currentGoal': 3, // Avalie 3 quizzes.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // Conquistador
    await users.doc('$userId').collection('missions').doc('5').set({
      'level': 1,
      'currentGoal': 3, // Complete 3 missões.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // Mestre
    await users.doc('$userId').collection('missions').doc('6').set({
      'level': 1,
      'currentGoal': 3, // Crie 3 quizzes.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // Amado
    await users.doc('$userId').collection('missions').doc('7').set({
      'level': 1,
      'currentGoal': 30, // Consiga 30 pontos de postagem na comunidade.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // Colecionador
    await users.doc('$userId').collection('missions').doc('8').set({
      'level': 1,
      'currentGoal': 3, // Obtenha 3 medalhas.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
  }

  Future<void> updateMission(
    int userId,
    int missionId,
    int currentValue,
    List goals,
    List devPointsRewards,
    List devCoinsRewards,
  ) async {
    var mission = await users
        .doc('$userId')
        .collection('missions')
        .doc('$missionId')
        .get();

    if ((currentValue >= mission.data()['currentGoal']) &&
        !mission.data()['isCompleted']) {
      await users.doc('$userId').update({
        'completedMissions': FieldValue.increment(1),
      });
      await users
          .doc('$userId')
          .collection('missions')
          .doc('$missionId')
          .update({
        'devPointsRewards':
            FieldValue.increment(devPointsRewards[mission.data()['level'] - 1]),
        'devCoinsRewards':
            FieldValue.increment(devCoinsRewards[mission.data()['level'] - 1]),
      });

      if (mission.data()['currentGoal'] >= goals[goals.length - 1]) {
        await users
            .doc('$userId')
            .collection('missions')
            .doc('$missionId')
            .update({'isCompleted': true});
      } else {
        await users
            .doc('$userId')
            .collection('missions')
            .doc('$missionId')
            .update({
          'level': FieldValue.increment(1),
          'currentGoal': goals[mission.data()['level']]
        });
      }
    }
  }

  Future<void> resetMissionReward(int userId, int missionId) async {
    await users.doc('$userId').collection('missions').doc('$missionId').update({
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
    });
  }

  Future<void> updateUser(int userId, String field, var newValue) async {
    await users
        .doc('$userId')
        .update({field: newValue})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> addQuizData(Map quizData, String quizId) async {
    await quizzes.doc(quizId).set(quizData);

    await users.doc('${quizData['userId']}').update({
      'totalCreatedQuizzes': FieldValue.increment(1),
    });
  }

  Future<void> addMedal(
    int userId,
    String kind,
    int medalId,
    String date,
  ) async {
    await users.doc('$userId').collection('medals').add({
      'kind': kind,
      'medalId': medalId,
      'date': date,
    });
    await users
        .doc('$userId')
        .update({
          'totalMedals': FieldValue.increment(1),
        })
        .then((value) => print("add medal to user"))
        .catchError((error) => print("Failed to add Medal: $error"));
  }

  Future<void> addRatedQuiz(int userId, String quizId, int amount) async {
    print('Rate: $amount');
    await users
        .doc('$userId')
        .update({'totalRatedQuizzes': FieldValue.increment(1)});
    await quizzes.doc(quizId).update({
      'totalRatings': FieldValue.increment(1),
      'ratingSum': FieldValue.increment(amount),
    });
    await quizzes
        .doc(quizId)
        .collection('ratings')
        .doc('$userId')
        .set({'amount': amount});
  }

  Future<void> addUserSolvedQuiz(
      int userId, Map quizData, String quizId) async {
    await users
        .doc('$userId')
        .collection('userSolvedQuizzes')
        .doc(quizId)
        .set(quizData);
  }

  Future<void> addQuizQuestion(Map questionData, String quizId) async {
    await quizzes.doc(quizId).collection('questions').add(questionData);
  }

  Stream<QuerySnapshot> getCreatedQuizzes() {
    return quizzes
        .where("kind", isEqualTo: "created")
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getFixedQuizzes() {
    return quizzes
        .where("kind", isEqualTo: "fixed")
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getQuestions(String quizId) {
    return quizzes.doc(quizId).collection('questions').snapshots();
  }

  Stream<QuerySnapshot> getUserMedals(int userId) {
    return users
        .doc('$userId')
        .collection('medals')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<bool> getUserSolvedQuizById(int userId, String quizId) async {
    bool result = true; // quiz possui recompensa, usuario não fez o quiz.
    await users
        .doc('$userId')
        .collection('userSolvedQuizzes')
        .doc(quizId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        result = false; // quiz não possui recompensa, usuario ja fez o quiz.
      }
    });
    return result;
  }

  Future<int> getUserRatedQuizById(int userId, String quizId) async {
    int result = 0; // usuário não avaliou o quiz.
    await quizzes
        .doc(quizId)
        .collection('ratings')
        .doc('$userId')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        result = documentSnapshot.data()['amount']; // usuário avaliou o quiz.
      }
    });
    return result;
  }

  Stream<DocumentSnapshot> getQuizById(String quizId) {
    return quizzes.doc(quizId).snapshots();
  }

  Stream<DocumentSnapshot> getMissionById(int userId, int missionId) {
    return users
        .doc('$userId')
        .collection('missions')
        .doc('$missionId')
        .snapshots();
  }

  Stream<DocumentSnapshot> getMedalById(String kind, int medalId) {
    return medals
        .doc('allMedals')
        .collection('$kind')
        .doc('$medalId')
        .snapshots();
  }

  Future<List<int>> getMedalsIdsByKind(String kind) async {
    List<int> result = []; // usuario não curtiu o post
    await medals
        .doc('allMedals')
        .collection('$kind')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        result.add(int.parse(doc.id));
      });
    });
    return result;
  }

  Future getMissionDataById(int userId, int missionId) {
    return users.doc('$userId').collection('missions').doc('$missionId').get();
  }

  Stream<QuerySnapshot> getHighlighted() {
    return highlighted.snapshots();
  }

  Stream<QuerySnapshot> getVisitCards() {
    return visitCards.snapshots();
  }

  Stream<QuerySnapshot> getVideos() {
    return videos.snapshots();
  }

  Future<void> addVideoSuggestion(String videoUrl) async {
    await videoSuggestions.add({
      "videoUrl": videoUrl,
    });
  }

  Stream<QuerySnapshot> getPosts() {
    return posts.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> updateRank() async {
    int i = 0;
    users
        .orderBy('devPoints', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        i++;
        if (doc.data()['rank'] != i) {
          users.doc(doc.id).update({'rank': i});
        }
      });
    });
  }

  Future<QuerySnapshot> getRankUsers() async {
    return users.orderBy('devPoints', descending: true).get();
  }

  Future<void> addPost(Map postData, String postId) async {
    await posts.doc(postId).set(postData);
  }

  Future<void> likePost(String postId, int userId, int creatorUserId) async {
    await posts.doc(postId).update({'postPoints': FieldValue.increment(10)});
    await users.doc('$userId').collection('likedPosts').doc(postId).set({
      'postId': postId,
    });
    await users.doc('$creatorUserId').update({
      'totalPostPoints': FieldValue.increment(10),
    });
  }

  Future<void> addVisitCardToUser(String visitCardId, int userId) async {
    await users
        .doc('$userId')
        .collection('userVisitCards')
        .doc(visitCardId)
        .set({
      'visitCardId': visitCardId,
    });
  }

  Future<void> deletePost(String postId) async {
    await posts.doc(postId).delete();
  }

  Future<void> deleteQuiz(String quizId) async {
    // delete questions of quiz
    await quizzes.doc(quizId).collection('questions').get().then((value) {
      value.docs.forEach((element) {
        quizzes.doc(quizId).collection('questions').doc(element.id).delete();
      });
    });

    // delete quiz
    await quizzes.doc(quizId).delete();
  }

  Stream<DocumentSnapshot> getUserVisitCardById(
      int userId, String visitCardId) {
    return users
        .doc('$userId')
        .collection('userVisitCards')
        .doc(visitCardId)
        .snapshots();
  }

  Stream<DocumentSnapshot> getUserLikedPostById(int userId, String postId) {
    return users
        .doc('$userId')
        .collection('likedPosts')
        .doc(postId)
        .snapshots();
  }

  Future<void> reportPost(String postId, int userId, String reason) async {
    await postsReports.doc(postId).collection('users').doc('$userId').set({
      'userId': userId,
      'reason': reason,
    });
  }

  Future<void> reportQuiz(String quizId, int userId, String reason) async {
    await quizzesReports.doc(quizId).collection('users').doc('$userId').set({
      'userId': userId,
      'reason': reason,
    });
  }
}
