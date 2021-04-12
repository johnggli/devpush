import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<Map<String, Object>> getUserById(int id) async {
    Map<String, Object> result;
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
          'totalLogin': 0,
          'loginStreak': 0,
          'missions': [
            {
              'id': 0,
              'level': 1,
              'currentGoal': 3,
              'isCompleted': false
            }, // sage
            {
              'id': 1,
              'level': 1,
              'currentGoal': 3,
              'isCompleted': false
            }, // on fire
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
}
