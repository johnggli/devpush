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
    await users.doc('$userId').set({
      'level': 1,
      'devPoints': 0,
      'devCoins': 0,
      'lastLogin': '',
      'totalLogin': 0,
      'loginStreak': 0,
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
      'reward': 0,
      'isCompleted': false,
    });
    // on fire
    await users.doc('$userId').collection('missions').doc('2').set({
      'name': 'Em Chamas!',
      'level': 1,
      'currentGoal': 3, // Entre no aplicativo por 3 dias seguidos.
      'reward': 0,
      'isCompleted': false,
    });
    // invincible
    await users.doc('$userId').collection('missions').doc('3').set({
      'name': 'Invencível',
      'level': 1,
      'currentGoal': 3, // Complete 3 quizzes sem errar nada.
      'reward': 0,
      'isCompleted': false,
    });
    // social
    await users.doc('$userId').collection('missions').doc('4').set({
      'name': 'Social',
      'level': 1,
      'currentGoal': 3, // Siga 3 pessoas no Github.
      'reward': 0,
      'isCompleted': false,
    });
    // conqueror
    await users.doc('$userId').collection('missions').doc('5').set({
      'name': 'Conquistador',
      'level': 1,
      'currentGoal': 3, // Complete 3 missões.
      'reward': 0,
      'isCompleted': false,
    });
    // contributor
    await users.doc('$userId').collection('missions').doc('6').set({
      'name': 'Contribuidor',
      'level': 1,
      'currentGoal': 3, // Crie 3 quizzes.
      'reward': 0,
      'isCompleted': false,
    });
    // beloved
    await users.doc('$userId').collection('missions').doc('7').set({
      'name': 'Amado',
      'level': 1,
      'currentGoal': 30, // Consiga 30 pontos em uma postagem sua.
      'reward': 0,
      'isCompleted': false,
    });
    // persevering
    await users.doc('$userId').collection('missions').doc('8').set({
      'name': 'Perseverante',
      'level': 1,
      'currentGoal': 10, // Complete 10 dias no DevPush.
      'reward': 0,
      'isCompleted': false,
    });
  }

  Future<void> updateLegendary(int userId) async {
    List goals = [3, 5, 7]; // Level
    List rewards = [30, 50, 70]; // DevPoints

    var user = await users.doc('$userId').get();
    var mission =
        await users.doc('$userId').collection('missions').doc('1').get();

    if (user.data()['level'] == mission.data()['currentGoal']) {
      await users.doc('$userId').collection('missions').doc('1').update({
        'reward': FieldValue.increment(rewards[mission.data()['level'] - 1])
      });

      if (mission.data()['currentGoal'] == goals[goals.length - 1]) {
        await users
            .doc('$userId')
            .collection('missions')
            .doc('1')
            .update({'isCompleted': true});
      } else {
        await users.doc('$userId').collection('missions').doc('1').update({
          'level': FieldValue.increment(1),
          'currentGoal': goals[mission.data()['level']]
        });
      }
    }
  }

  Future<void> receiveLegendaryReward(int userId) async {
    var user = await users.doc('$userId').get();
    var mission =
        await users.doc('$userId').collection('missions').doc('1').get();

    int newValue = user.data()['devPoints'] + mission.data()['reward'];

    await updateUser(userId, 'devPoints', newValue);

    await users
        .doc('$userId')
        .collection('missions')
        .doc('1')
        .update({'reward': 0});
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

  Stream<DocumentSnapshot> getLegendary(int userId) {
    return users.doc('$userId').collection('missions').doc('1').snapshots();
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
    await posts.doc(postId).update({"postPoints": FieldValue.increment(10)});
    await users
        .doc('$userId')
        .collection('likedPosts')
        .doc(postId)
        .set({'postId': postId});
    await users
        .doc('$creatorUserId')
        .update({"devPoints": FieldValue.increment(10)});
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
