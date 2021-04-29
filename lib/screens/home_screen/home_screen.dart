import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/models/github_user_model.dart';
import 'package:devpush/models/mission_model.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/providers/github_provider.dart';
import 'package:devpush/providers/page_provider.dart';
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
        .setContributionsOfDate(currentDate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var githubProvider = Provider.of<GithubProvider>(context);
    var databaseProvider = Provider.of<DatabaseProvider>(context);
    var pageProvider = Provider.of<PageProvider>(context);

    GithubUserModel githubUser = githubProvider.user;
    UserModel user = databaseProvider.user;

    MissionModel sage = user.missions[0];
    // List<Map<String, dynamic>> missions = databaseProvider.missions;

    int todayContributions = githubProvider.todayContributions;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'DevPush',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 48),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.blue, width: 4),
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(githubUser.avatarUrl ?? ''),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(
                    // githubUser.login,
                    'John Emerson',
                    style: AppTextStyles.head,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Level ${user.level}',
                    style: AppTextStyles.subHead,
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(height: 24),
          Text('todayContributions: $todayContributions'),
          SizedBox(height: 24),
          Text('user devPoints: ${user.devPoints}'),
          SizedBox(height: 24),
          TextButton(
            onPressed: () {
              pageProvider.setLoading(true);
              databaseProvider.addDevPoints(50).then((_) {
                pageProvider.setLoading(false);
              });
            },
            child: Text(
              "(+50)",
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Text('Sábio'),
                        Text('Nível ${sage.level}'),
                        sage.reward > 0
                            ? TextButton(
                                onPressed: () {
                                  pageProvider.setLoading(true);
                                  databaseProvider
                                      .receiveSageReward()
                                      .then((_) {
                                    pageProvider.setLoading(false);
                                  });
                                },
                                child: Text(
                                  "Receber",
                                ),
                              )
                            : sage.isCompleted
                                ? Text('Completo')
                                : Column(
                                    children: [
                                      Text(
                                          'Alcance o level ${sage.currentGoal}.'),
                                      Text(
                                          'Progresso: ${user.level / sage.currentGoal}')
                                    ],
                                  ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  height: 100,
                  color: Colors.grey[500],
                  child: Center(
                    child: Column(
                      children: [
                        Text('Sage'),
                        Text('Descrição pika'),
                        Text('Nível 3'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  height: 100,
                  color: Colors.grey[500],
                  child: Center(
                    child: Column(
                      children: [
                        Text('Sage'),
                        Text('Descrição pika'),
                        Text('Nível 3'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  height: 100,
                  color: Colors.grey[500],
                  child: Center(
                    child: Column(
                      children: [
                        Text('Sage'),
                        Text('Descrição pika'),
                        Text('Nível 3'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  height: 100,
                  color: Colors.grey[500],
                  child: Center(
                    child: Column(
                      children: [
                        Text('Sage'),
                        Text('Descrição pika'),
                        Text('Nível 3'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          )
          // Expanded(
          //   child: ListView.separated(
          //     padding: const EdgeInsets.all(8),
          //     itemCount: entries.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return Container(
          //         height: 50,
          //         color: Colors.amber[500],
          //         child: Center(child: Text('Entry ${entries[index]}')),
          //       );
          //     },
          //     separatorBuilder: (BuildContext context, int index) =>
          //         SizedBox(height: 12),
          //   ),
          // )

          // Expanded(
          //   child: ListView(
          //     children: missions.map((e) {
          //       return Container(
          //         color: e,
          //         height: 100,
          //       );
          //     }).toList(),
          //   ),
          // ),
          // TextButton(
          //   onPressed: () => addUser(123456, 'John Emerson', 7),
          //   child: Text(
          //     "Add User",
          //   ),
          // )
          // TextButton(
          //   onPressed: () => databaseProvider.setUser(79942716),
          //   child: Text(
          //     "databaseProvider.setUser(79942716)",
          //   ),
          // ),
          // TextButton(
          //   onPressed: () => databaseProvider.getUsers(),
          //   child: Text(
          //     "databaseProvider.getUsers()",
          //   ),
          // ),
          // TextButton(
          //   onPressed: () => databaseProvider.createUser(79942716),
          //   child: Text(
          //     "databaseProvider.createUser(79942716)",
          //   ),
          // )
        ],
      ),
    );
  }
}
