import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference quizzes =
      FirebaseFirestore.instance.collection('quizzes');
  CollectionReference highlighted =
      FirebaseFirestore.instance.collection('highlighted');

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

  Future<DocumentSnapshot> getQuizById(String quizId) async {
    return quizzes.doc(quizId).get();
  }

  Future<DocumentSnapshot> getHighlighted() async {
    return highlighted.limit(1).get().then(
      (value) {
        if (value.docs.length > 0) {
          return value.docs[0];
        } else {
          return null;
        }
      },
    );
  }
}
