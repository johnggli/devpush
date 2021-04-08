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
              'title': 'Sábio',
              'description': 'Alcance o nível requisitado.',
              'level': 1,
              'current': 0,
              'goals': [3, 5, 7, 10, 15, 20, 25],
              'completed': false
            },
            {
              'title': 'Em Chamas',
              'description': 'Faça login consecutivamente.',
              'level': 1,
              'current': 0,
              'goals': [3, 5, 7, 10, 15, 20, 25, 30],
              'completed': false
            }
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

  Future<void> updateUser(int userId, String field, int newValue) async {
    await users
        .doc('$userId')
        .update({field: newValue})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
