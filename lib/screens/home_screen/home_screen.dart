import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/github_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        .getContributionsOfDate(currentDate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var githubProvider = Provider.of<GithubProvider>(context);

    UserModel user = githubProvider.user;

    int todayContributions = githubProvider.todayContributions;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.red,
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
          ],
        ),
      ),
    );
  }
}
