import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/components/mission_card.dart';
import 'package:devpush/components/progress_bar.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/models/github_user_model.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/home_screen/components/empty_card.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final GithubUserModel githubUser;
  final UserModel user;
  const HomeScreen({
    Key key,
    @required this.githubUser,
    @required this.user,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);
    // List<Map<String, dynamic>> missions = databaseProvider.missions;

    // int todayContributions = githubProvider.todayContributions;

    return Scaffold(
      backgroundColor: Colors.white,
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
          Column(
            children: [
              ClipOval(
                child: Container(
                  height: 150,
                  width: 150,
                  child: FancyShimmerImage(
                    shimmerBaseColor: Colors.grey[300],
                    shimmerHighlightColor: Colors.grey[100],
                    imageUrl:
                        'https://avatars.githubusercontent.com/u/43749971?v=4',
                  ),

                  // FadeInImage(
                  //   placeholder: AssetImage(AppImages.defaultImage),
                  //   image: NetworkImage(
                  //       'https://avatars.githubusercontent.com/u/43749971?v=4'),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // widget.githubUser.avatarUrl
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(
                    widget.githubUser.login,
                    // 'John Emerson',
                    style: AppTextStyles.section,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Level ${widget.user.level}',
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
                      Icons.bolt,
                      color: AppColors.blue,
                      size: 16,
                    ),
                    Text(
                      '${widget.user.devPoints}',
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
                  value: ((widget.user.devPoints) -
                          (pow((widget.user.level) * 4, 2))) /
                      ((pow((widget.user.level + 1) * 4, 2)) -
                          (pow((widget.user.level) * 4, 2))),
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
                      '${pow((widget.user.level + 1) * 4, 2)}',
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
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              'Missões',
              style: AppTextStyles.section,
            ),
          ),
          SizedBox(height: 12),
          StreamBuilder<DocumentSnapshot>(
            stream: databaseProvider.getMissionById(widget.githubUser.id, 1),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                return MissionCard(
                  name: snapshot.data['name'],
                  desc: 'Alcance o level ${snapshot.data['currentGoal']}',
                  level: snapshot.data['level'],
                  reward: snapshot.data['devPointsRewards'],
                  isCompleted: snapshot.data['isCompleted'],
                  currentGoal: snapshot.data['currentGoal'],
                  color: AppColors.green,
                  currentProgress: widget.user.level,
                  onTap: () {
                    databaseProvider.receiveMissionReward(1);
                  },
                  icon: Icon(
                    Icons.auto_stories,
                    color: Colors.white,
                  ),
                );
              }
              return EmptyCard();
            },
          ),
          SizedBox(height: 10),
          StreamBuilder<DocumentSnapshot>(
            stream: databaseProvider.getMissionById(widget.githubUser.id, 2),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                return MissionCard(
                  name: snapshot.data['name'],
                  desc:
                      'Entre no aplicativo por ${snapshot.data['currentGoal']} dias seguidos.',
                  level: snapshot.data['level'],
                  reward: snapshot.data['devPointsRewards'],
                  isCompleted: snapshot.data['isCompleted'],
                  currentGoal: snapshot.data['currentGoal'],
                  color: AppColors.red,
                  currentProgress: widget.user.loginStreak,
                  onTap: () {
                    databaseProvider.receiveMissionReward(2);
                  },
                  icon: Icon(
                    Icons.local_fire_department,
                    color: Colors.white,
                  ),
                );
              }
              return EmptyCard();
            },
          ),
          SizedBox(height: 10),
          StreamBuilder<DocumentSnapshot>(
            stream: databaseProvider.getMissionById(widget.githubUser.id, 3),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                return MissionCard(
                  name: snapshot.data['name'],
                  desc:
                      'Complete ${snapshot.data['currentGoal']} quizzes sem errar nada.',
                  level: snapshot.data['level'],
                  reward: snapshot.data['devPointsRewards'],
                  isCompleted: snapshot.data['isCompleted'],
                  currentGoal: snapshot.data['currentGoal'],
                  color: AppColors.purple,
                  currentProgress: widget.user.wins,
                  onTap: () {
                    databaseProvider.receiveMissionReward(3);
                  },
                  icon: Icon(
                    Icons.assignment_turned_in,
                    color: Colors.white,
                  ),
                );
              }
              return EmptyCard();
            },
          ),
          SizedBox(height: 10),
          StreamBuilder<DocumentSnapshot>(
            stream: databaseProvider.getMissionById(widget.githubUser.id, 4),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                return MissionCard(
                  name: snapshot.data['name'],
                  desc:
                      'Siga ${snapshot.data['currentGoal']} pessoas no Github.',
                  level: snapshot.data['level'],
                  reward: snapshot.data['devPointsRewards'],
                  isCompleted: snapshot.data['isCompleted'],
                  currentGoal: snapshot.data['currentGoal'],
                  color: AppColors.dark,
                  currentProgress: widget.user.following,
                  onTap: () {
                    databaseProvider.receiveMissionReward(4);
                  },
                  icon: Icon(
                    Icons.group_add,
                    color: Colors.white,
                  ),
                );
              }
              return EmptyCard();
            },
          ),
          SizedBox(height: 24),
          TextButton(
            onPressed: () {
              databaseProvider.addDevPoints(50);
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
