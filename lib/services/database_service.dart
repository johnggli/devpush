import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<Map<String, dynamic>> getUserById(int id) async {
    Map<String, dynamic> result;
    await users.doc('$id').get().then((DocumentSnapshot documentSnapshot) {
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

    await users.doc('$userId').set({
      'level': 1,
      'devPoints': 0,
      'devCoins': 0,
      'lastLogin': lastLogin,
      'totalLogin': 0,
      'loginStreak': 0,
      'wins': 0,
      'following': 0,
    }).then(
      (_) => initMissionsOfUser(userId)
          .then((_) => print("User Added"))
          .catchError((error) => print("Failed to create user: $error")),
    );
  }

  Future<void> initMissionsOfUser(int userId) async {
    // legendary
    await users.doc('$userId').collection('missions').doc('1').set({
      'name': 'Lendário',
      'level': 1,
      'currentGoal': 3, // Alcance o Level 3.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // on fire
    await users.doc('$userId').collection('missions').doc('2').set({
      'name': 'Em Chamas!',
      'level': 1,
      'currentGoal': 3, // Entre no aplicativo por 3 dias seguidos.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // invincible
    await users.doc('$userId').collection('missions').doc('3').set({
      'name': 'Invencível',
      'level': 1,
      'currentGoal': 3, // Complete 3 quizzes sem errar nada.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // social
    await users.doc('$userId').collection('missions').doc('4').set({
      'name': 'Social',
      'level': 1,
      'currentGoal': 3, // Siga 3 pessoas no Github.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // conqueror
    await users.doc('$userId').collection('missions').doc('5').set({
      'name': 'Conquistador',
      'level': 1,
      'currentGoal': 3, // Complete 3 missões.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // contributor
    await users.doc('$userId').collection('missions').doc('6').set({
      'name': 'Contribuidor',
      'level': 1,
      'currentGoal': 3, // Crie 3 quizzes.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // beloved
    await users.doc('$userId').collection('missions').doc('7').set({
      'name': 'Amado',
      'level': 1,
      'currentGoal': 30, // Consiga 30 pontos de postagem na comunidade.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
    // persevering
    await users.doc('$userId').collection('missions').doc('8').set({
      'name': 'Perseverante',
      'level': 1,
      'currentGoal': 10, // Complete 10 dias no DevPush.
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
      'isCompleted': false,
    });
  }

  Future<void> updateMission(
    int userId,
    int missionId,
    String attribute,
    List goals,
    List devPointsRewards,
    List devCoinsRewards,
  ) async {
    var user = await users.doc('$userId').get();
    var mission = await users
        .doc('$userId')
        .collection('missions')
        .doc('$missionId')
        .get();

    if ((user.data()[attribute] >= goals[goals.length - 1]) &&
        (mission.data()['currentGoal'] == goals[0])) {
      await users
          .doc('$userId')
          .collection('missions')
          .doc('$missionId')
          .update({'isCompleted': true});
      await users
          .doc('$userId')
          .collection('missions')
          .doc('$missionId')
          .update({
        'devPointsRewards':
            FieldValue.increment(devPointsRewards.reduce((a, b) => a + b)),
        'devCoinsRewards':
            FieldValue.increment(devCoinsRewards.reduce((a, b) => a + b)),
      });
      await users
          .doc('$userId')
          .collection('missions')
          .doc('$missionId')
          .update({
        'level': goals.length,
        'currentGoal': goals[goals.length - 1],
      });
    } else {
      if ((user.data()[attribute] >= mission.data()['currentGoal']) &&
          !mission.data()['isCompleted']) {
        await users
            .doc('$userId')
            .collection('missions')
            .doc('$missionId')
            .update({
          'devPointsRewards': FieldValue.increment(
              devPointsRewards[mission.data()['level'] - 1]),
          'devCoinsRewards': FieldValue.increment(
              devCoinsRewards[mission.data()['level'] - 1]),
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
  }

  Future<void> resetMissionReward(int userId, int missionId) async {
    await users.doc('$userId').collection('missions').doc('$missionId').update({
      'devPointsRewards': 0,
      'devCoinsRewards': 0,
    });
  }

  Future<void> getUsers() {
    return users.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.id);
        print(doc.data());
        // print(doc["first_name"]);
      });
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
    await quizzes
        .doc(quizId)
        .set(quizData)
        .then((_) => print("Quiz Data Added"))
        .catchError((error) => print("Failed to add quiz data: $error"));
  }

  Future<void> addUserSolvedQuiz(
      int userId, Map quizData, String quizId) async {
    await users
        .doc('$userId')
        .collection('userSolvedQuizzes')
        .doc(quizId)
        .set(quizData)
        .then((_) => print("User Solved Quiz Added"))
        .catchError((error) => print("Failed to add User Solved Quiz: $error"));
  }

  Future<void> addQuizQuestion(Map questionData, String quizId) async {
    await quizzes
        .doc(quizId)
        .collection('questions')
        .add(questionData)
        .then((_) => print("Quiz Question Data Added"))
        .catchError(
            (error) => print("Failed to add quiz question data: $error"));
  }

  Stream<QuerySnapshot> getAllQuizzes() {
    return quizzes.snapshots();
  }

  Stream<QuerySnapshot> getQuestions(String quizId) {
    return quizzes.doc(quizId).collection('questions').snapshots();
  }

  Future<void> updateQuiz(String quizId, String field, var newValue) async {
    await quizzes
        .doc(quizId)
        .update({field: newValue})
        .then((value) => print("Quiz Updated"))
        .catchError((error) => print("Failed to update quiz: $error"));
  }

  Future<bool> getUserSolvedQuizById(int userId, String quizId) async {
    bool result = true; // usuario não fez o quiz
    await users
        .doc('$userId')
        .collection('userSolvedQuizzes')
        .doc(quizId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        result = false; // usuario fez o quiz
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

  Future getMissionDataById(int userId, int missionId) {
    return users.doc('$userId').collection('missions').doc('$missionId').get();
  }

  Stream<QuerySnapshot> getHighlighted() {
    return highlighted.snapshots();
  }

  Stream<QuerySnapshot> getVideos() {
    return videos.snapshots();
  }

  Future<void> addVideoSuggestion(String videoUrl) async {
    await videoSuggestions
        .add({"videoUrl": videoUrl})
        .then((_) => print("Video Suggestion Added"))
        .catchError((error) => print("Failed to add Video Suggestion: $error"));
  }

  Stream<QuerySnapshot> getPosts() {
    return posts.orderBy('postDateTime', descending: true).snapshots();
  }

  Future<void> addPost(Map postData, String postId) async {
    await posts
        .doc(postId)
        .set(postData)
        .then((_) => print("Post Added"))
        .catchError((error) => print("Failed to add Post: $error"));
  }

  Future<void> likePost(String postId, int userId, int creatorUserId) async {
    await posts.doc(postId).update({'postPoints': FieldValue.increment(10)});
    await users
        .doc('$userId')
        .collection('likedPosts')
        .doc(postId)
        .set({'postId': postId});
    // await users
    //     .doc('$creatorUserId')
    //     .update({'devPoints': FieldValue.increment(10)});
    // await addDevPoints(creatorUserId, 10);
  }

  Future<void> deletePost(String postId) async {
    await posts.doc(postId).delete();
  }

  Future<bool> getUserLikedPostById(int userId, String postId) async {
    bool result = false; // usuario não curtiu o post
    await users
        .doc('$userId')
        .collection('likedPosts')
        .doc(postId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        result = true; // usuario curtiu o post
      }
    });
    return result;
  }

  Future<void> reportPost(String postId, int userId, String reason) async {
    await postsReports.doc(postId).collection('users').doc('$userId').set({
      'userId': userId,
      'reason': reason,
    });
  }
}
