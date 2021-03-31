import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/github_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentDate() {
    String now = DateTime.now().toString();
    var date = now.split(' ')[0];
    return date; // something like "2021-03-21"
  }

  @override
  void initState() {
    Provider.of<GithubProvider>(context, listen: false)
        .setContributionsOfDate(currentDate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var githubProvider = Provider.of<GithubProvider>(context);

    UserModel user = githubProvider.user;

    int todayContributions = githubProvider.todayContributions;

    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser(int id, String login, int totalLogin) {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'id': id, // John Doe
            'login': login, // Stokes and Sons
            'totalLogin': totalLogin // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 4),
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(user.avatarUrl ?? ''),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Name: ${user.login}'),
            Text('todayContributions: $todayContributions'),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => addUser(123456, 'John Emerson', 7),
              child: Text(
                "Add User",
              ),
            )
          ],
        ),
      ),
    );
  }
}
