import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // Future writeStorageData(String key, String value) async {
  //   var writeData = await _storage.write(key: key, value: value);
  //   return writeData;
  // }

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(int id) {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'id': id, // 79942716
          'level': 1,
          'devPoints': 0,
          'totalLogin': 0,
          'loginStreak': 0,
          'devMissions': []
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
