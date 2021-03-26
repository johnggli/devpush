import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/github_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var githubProvider = Provider.of<GithubProvider>(context);
    UserModel user = githubProvider.user;

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
            ElevatedButton(
              onPressed: () async {
                await githubProvider
                    .getContributionsOfDate('insira a data aqui');
              },
              child: const Text('mostrar contribs'),
            ),
          ],
        ),
      ),
    );
  }
}
