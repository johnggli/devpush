import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/components/mission_card.dart';
import 'package:devpush/components/progress_bar.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/home_screen/components/empty_card.dart';
import 'package:devpush/screens/store_screen/store_screen.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> setup() async {
    Provider.of<DatabaseProvider>(context, listen: false).setFollowing(true);
    Provider.of<DatabaseProvider>(context, listen: false)
        .setCompletedMissions();
    Provider.of<DatabaseProvider>(context, listen: false)
        .setTotalCreatedQuizzes();
  }

  @override
  void initState() {
    Provider.of<DatabaseProvider>(context, listen: false).setFollowing(false);
    Provider.of<DatabaseProvider>(context, listen: false)
        .setCompletedMissions();
    Provider.of<DatabaseProvider>(context, listen: false).setTotalPostPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreScreen(),
                  ),
                );
              },
              child: Chip(
                labelPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                avatar: CircleAvatar(
                  backgroundColor: Colors.yellow[500],
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.yellow[700],
                    ),
                    child: Icon(
                      Icons.code,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                label: Text(
                  '${widget.user.devCoins}',
                  style: AppTextStyles.label,
                ),
                backgroundColor: AppColors.blue,
                // elevation: 6.0,
                shadowColor: Colors.grey[60],
                padding: EdgeInsets.all(6),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.blue,
        strokeWidth: 3,
        onRefresh: setup,
        child: ListView(
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
                      imageUrl: widget.user.avatarUrl,
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
                      widget.user.login,
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
              // legendary
              stream: databaseProvider.getMissionById(widget.user.id, 1),
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
                      Icons.auto_awesome,
                      color: Colors.white,
                    ),
                  );
                }
                return EmptyCard();
              },
            ),
            SizedBox(height: 10),

            StreamBuilder<DocumentSnapshot>(
              // on fire
              stream: databaseProvider.getMissionById(widget.user.id, 2),
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
              // contributor
              stream: databaseProvider.getMissionById(widget.user.id, 6),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return MissionCard(
                    name: snapshot.data['name'],
                    desc: 'Crie ${snapshot.data['currentGoal']} quizzes.',
                    level: snapshot.data['level'],
                    reward: snapshot.data['devPointsRewards'],
                    isCompleted: snapshot.data['isCompleted'],
                    currentGoal: snapshot.data['currentGoal'],
                    color: AppColors.blue,
                    currentProgress: widget.user.totalCreatedQuizzes,
                    onTap: () {
                      databaseProvider.receiveMissionReward(6);
                    },
                    icon: Icon(
                      Icons.library_add,
                      color: Colors.white,
                    ),
                  );
                }
                return EmptyCard();
              },
            ),
            SizedBox(height: 10),

            StreamBuilder<DocumentSnapshot>(
              // invincible
              stream: databaseProvider.getMissionById(widget.user.id, 3),
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
                      Icons.verified_user,
                      color: Colors.white,
                    ),
                  );
                }
                return EmptyCard();
              },
            ),
            SizedBox(height: 10),

            StreamBuilder<DocumentSnapshot>(
              // beloved
              stream: databaseProvider.getMissionById(widget.user.id, 7),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return MissionCard(
                    name: snapshot.data['name'],
                    desc:
                        'Consiga ${snapshot.data['currentGoal']} pontos de postagem na comunidade.',
                    level: snapshot.data['level'],
                    reward: snapshot.data['devPointsRewards'],
                    isCompleted: snapshot.data['isCompleted'],
                    currentGoal: snapshot.data['currentGoal'],
                    color: AppColors.pink,
                    currentProgress: widget.user.totalPostPoints,
                    onTap: () {
                      databaseProvider.receiveMissionReward(7);
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                  );
                }
                return EmptyCard();
              },
            ),
            SizedBox(height: 10),

            // social
            StreamBuilder<DocumentSnapshot>(
              stream: databaseProvider.getMissionById(widget.user.id, 4),
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
                    color: AppColors.gray,
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
            SizedBox(height: 10),

            StreamBuilder<DocumentSnapshot>(
              // conqueror
              stream: databaseProvider.getMissionById(widget.user.id, 5),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return MissionCard(
                    name: snapshot.data['name'],
                    desc: 'Complete ${snapshot.data['currentGoal']} missões.',
                    level: snapshot.data['level'],
                    reward: snapshot.data['devPointsRewards'],
                    isCompleted: snapshot.data['isCompleted'],
                    currentGoal: snapshot.data['currentGoal'],
                    color: AppColors.yellow,
                    currentProgress: widget.user.completedMissions,
                    onTap: () {
                      databaseProvider.receiveMissionReward(5);
                    },
                    icon: Icon(
                      Icons.military_tech,
                      color: Colors.white,
                    ),
                  );
                }
                return EmptyCard();
              },
            ),
            SizedBox(height: 10),

            // persevering
            StreamBuilder<DocumentSnapshot>(
              stream: databaseProvider.getMissionById(widget.user.id, 8),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return MissionCard(
                    name: snapshot.data['name'],
                    desc:
                        'Complete ${snapshot.data['currentGoal']} dias de Login no DevPush.',
                    level: snapshot.data['level'],
                    reward: snapshot.data['devPointsRewards'],
                    isCompleted: snapshot.data['isCompleted'],
                    currentGoal: snapshot.data['currentGoal'],
                    color: AppColors.teal,
                    currentProgress: widget.user.totalLogin,
                    onTap: () {
                      databaseProvider.receiveMissionReward(8);
                    },
                    icon: Icon(
                      Icons.self_improvement,
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
          ],
        ),
      ),
    );
  }
}
