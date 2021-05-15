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

  Future createUser(int id) async {
    await users
        .doc('$id')
        .set({
          'level': 1,
          'devPoints': 0,
          'devCoins': 0,
          'totalLogin': 0,
          'loginStreak': 0,
          'missions': [
            {
              'id': 0, // sage
              'level': 1,
              'currentGoal': 3,
              'reward': 0,
              'isCompleted': false
            },
            {
              'id': 1, // on fire
              'level': 1,
              'currentGoal': 3,
              'reward': 0,
              'isCompleted': false
            },
          ]
        })
        .then((_) => print("User Added"))
        .catchError((error) => print("Failed to create user: $error"));
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
}
