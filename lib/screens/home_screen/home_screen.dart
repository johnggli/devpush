import 'dart:math';

import 'package:devpush/components/mission_card.dart';
import 'package:devpush/components/progress_bar.dart';
import 'package:devpush/core/app_colors.dart';
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
                    githubUser.login,
                    // 'John Emerson',
                    style: AppTextStyles.section,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Level ${user.level}',
                    style: AppTextStyles.subHead,
                  ),
                  SizedBox(height: 2),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.flash_on,
                      color: AppColors.blue,
                      size: 16,
                    ),
                    Text(
                      '${user.devPoints}',
                      style: AppTextStyles.blueText,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ProgressBar(
                  value: user.devPoints / pow((user.level + 1) * 4, 2),
                  color: AppColors.chartPrimary,
                  height: 5,
                ),
              ),
              Container(
                width: 100,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${pow((user.level + 1) * 4, 2)}',
                      style: AppTextStyles.grayText,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Divider(
            thickness: 1,
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              'Missões',
              style: AppTextStyles.section,
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(
                    color: AppColors.light,
                  ),
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.green,
                        ),
                        child: Icon(
                          Icons.auto_stories,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Nível ${sage.level}',
                        style: AppTextStyles.greenText,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sábio',
                          style: AppTextStyles.subHead,
                        ),
                        sage.reward > 0
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  height: 36,
                                  width: double.maxFinite,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.green),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      // side: MaterialStateProperty.all(BorderSide(color: borderColor)),
                                    ),
                                    onPressed: () {
                                      pageProvider.setLoading(true);
                                      databaseProvider
                                          .receiveSageReward()
                                          .then((_) {
                                        pageProvider.setLoading(false);
                                      });
                                    },
                                    child: Text(
                                      'Receber',
                                      style: AppTextStyles.buttonText,
                                    ),
                                  ),
                                ),
                              )
                            : sage.isCompleted
                                ? Row(
                                    children: [
                                      Text(
                                        'Completado',
                                        style: AppTextStyles.grayText,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Icon(
                                        Icons.check,
                                        size: 16,
                                        color: AppColors.green,
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Alcance o level ${sage.currentGoal}.',
                                        style: AppTextStyles.grayText,
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Stack(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 1,
                                              ),
                                              ProgressBar(
                                                value: user.level /
                                                    sage.currentGoal,
                                                color: AppColors.green,
                                                height: 14,
                                              ),
                                            ],
                                          ),
                                          Center(
                                            child: Text(
                                              '${user.level}/${sage.currentGoal}',
                                              style: AppTextStyles.whiteText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          MissionCard(
              mission: sage,
              currentProgress: user.level,
              onTap: () {
                pageProvider.setLoading(true);
                databaseProvider.receiveSageReward().then((_) {
                  pageProvider.setLoading(false);
                });
              }),
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
