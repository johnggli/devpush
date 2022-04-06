import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/components/mission_card.dart';
import 'package:devpush/components/progress_bar.dart';
import 'package:devpush/components/reward_dialog.dart';
import 'package:devpush/components/user_balance.dart';
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
    await Provider.of<DatabaseProvider>(context, listen: false)
        .refreshMissions();
  }

  @override
  void initState() {
    setup();
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   var welcomeBonus =
    //       Provider.of<DatabaseProvider>(context, listen: false).welcomeBonus;

    //   if (welcomeBonus == true) {
    //     showDialog(
    //       context: context,
    //       builder: (context) => WelcomeDialog(),
    //     );
    //   }
    // });
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
                label: UserBalance(),
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
              stream: databaseProvider.getMissionById(widget.user.id, 1),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return MissionCard(
                    name: 'Lendário',
                    desc: 'Alcance o level ${snapshot.data['currentGoal']}',
                    detailDesc:
                        'Obtenha DevPoints e suba seu level de usuário para receber as recompensas!\n\nVocê pode obter DevPoints resolvendo quizzes e completando missões.',
                    level: snapshot.data['level'],
                    reward: snapshot.data['devPointsRewards'],
                    isCompleted: snapshot.data['isCompleted'],
                    currentGoal: snapshot.data['currentGoal'],
                    color: AppColors.green,
                    currentProgress: widget.user.level,
                    onTap: () async {
                      List _rewards =
                          await databaseProvider.receiveMissionReward(1);
                      showDialog(
                        context: context,
                        builder: (context) => RewardDialog(
                          devPoints: _rewards[0],
                          devCoins: _rewards[1],
                        ),
                      );
                      setup();
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
              stream: databaseProvider.getMissionById(widget.user.id, 2),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return MissionCard(
                    name: 'Em Chamas!',
                    desc:
                        'Entre no aplicativo por ${snapshot.data['currentGoal']} dias seguidos.',
                    detailDesc:
                        'Faça Login no DevPush todos os dias para obter as recompensas!',
                    level: snapshot.data['level'],
                    reward: snapshot.data['devPointsRewards'],
                    isCompleted: snapshot.data['isCompleted'],
                    currentGoal: snapshot.data['currentGoal'],
                    color: Colors.redAccent,
                    currentProgress: widget.user.loginStreak,
                    onTap: () async {
                      List _rewards =
                          await databaseProvider.receiveMissionReward(2);
                      showDialog(
                        context: context,
                        builder: (context) => RewardDialog(
                          devPoints: _rewards[0],
                          devCoins: _rewards[1],
                        ),
                      );
                      setup();
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
              stream: databaseProvider.getMissionById(widget.user.id, 6),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return MissionCard(
                    name: 'Mestre',
                    desc: 'Crie ${snapshot.data['currentGoal']} quizzes.',
                    detailDesc:
                        'Ao criar quizzes, você contribui com o DevPush e ajuda outros usuários.\n\nCrie alguns quizzes para obter as recompensas!',
                    level: snapshot.data['level'],
                    reward: snapshot.data['devPointsRewards'],
                    isCompleted: snapshot.data['isCompleted'],
                    currentGoal: snapshot.data['currentGoal'],
                    color: Colors.blueAccent,
                    currentProgress: widget.user.totalCreatedQuizzes,
                    onTap: () async {
                      List _rewards =
                          await databaseProvider.receiveMissionReward(6);
                      showDialog(
                        context: context,
                        builder: (context) => RewardDialog(
                          devPoints: _rewards[0],
                          devCoins: _rewards[1],
                        ),
                      );
                      setup();
                    },
                    icon: Icon(
                      Icons.school,
                      color: Colors.white,
                    ),
                  );
                }
                return EmptyCard();
              },
            ),
            SizedBox(height: 10),
            StreamBuilder<DocumentSnapshot>(
              stream: databaseProvider.getMissionById(widget.user.id, 3),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return MissionCard(
                    name: 'Invencível',
                    desc:
                        'Complete ${snapshot.data['currentGoal']} quizzes sem errar nada.',
                    detailDesc:
                        'Demonstre que você não deixa nenhuma questão te vencer!\n\nResolve quizzes sem errar nenhuma questão para obter as recompensas!',
                    level: snapshot.data['level'],
                    reward: snapshot.data['devPointsRewards'],
                    isCompleted: snapshot.data['isCompleted'],
                    currentGoal: snapshot.data['currentGoal'],
                    color: AppColors.purple,
                    currentProgress: widget.user.wins,
                    onTap: () async {
                      List _rewards =
                          await databaseProvider.receiveMissionReward(3);
                      showDialog(
                        context: context,
                        builder: (context) => RewardDialog(
                          devPoints: _rewards[0],
                          devCoins: _rewards[1],
                        ),
                      );
                      setup();
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
              stream: databaseProvider.getMissionById(widget.user.id, 7),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return MissionCard(
                    name: 'Amado',
                    desc:
                        'Consiga ${snapshot.data['currentGoal']} pontos de postagem na comunidade.',
                    detailDesc:
                        'Participe da comunidade e ganhe pontos por cada curtida que outros usuários derem na sua postagem!',
                    level: snapshot.data['level'],
                    reward: snapshot.data['devPointsRewards'],
                    isCompleted: snapshot.data['isCompleted'],
                    currentGoal: snapshot.data['currentGoal'],
                    color: AppColors.pink,
                    currentProgress: widget.user.totalPostPoints,
                    onTap: () async {
                      List _rewards =
                          await databaseProvider.receiveMissionReward(7);
                      showDialog(
                        context: context,
                        builder: (context) => RewardDialog(
                          devPoints: _rewards[0],
                          devCoins: _rewards[1],
                        ),
                      );
                      setup();
                    },
                    icon: Icon(
                      Icons.volunteer_activism,
                      color: Colors.white,
                    ),
                  );
                }
                return EmptyCard();
              },
            ),
            SizedBox(height: 10),
            StreamBuilder<DocumentSnapshot>(
              stream: databaseProvider.getMissionById(widget.user.id, 4),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return MissionCard(
                    name: 'Crítico',
                    desc: 'Avalie ${snapshot.data['currentGoal']} quizzes.',
                    detailDesc:
                        'Ao completar um quiz, você pode dar a ele uma nota de até 5 estrelas!\n\nAvalie quizzes para obter as recompensas!',
                    level: snapshot.data['level'],
                    reward: snapshot.data['devPointsRewards'],
                    isCompleted: snapshot.data['isCompleted'],
                    currentGoal: snapshot.data['currentGoal'],
                    color: AppColors.yellow,
                    currentProgress: widget.user.totalRatedQuizzes,
                    onTap: () async {
                      List _rewards =
                          await databaseProvider.receiveMissionReward(4);
                      showDialog(
                        context: context,
                        builder: (context) => RewardDialog(
                          devPoints: _rewards[0],
                          devCoins: _rewards[1],
                        ),
                      );
                      setup();
                    },
                    icon: Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                  );
                }
                return EmptyCard();
              },
            ),
            SizedBox(height: 10),
            StreamBuilder<DocumentSnapshot>(
              stream: databaseProvider.getMissionById(widget.user.id, 5),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return MissionCard(
                    name: 'Conquistador',
                    desc: 'Complete ${snapshot.data['currentGoal']} missões.',
                    detailDesc:
                        'Completar uma missão é uma grande conquista!\n\nComplete missões para obter as recompensas!',
                    level: snapshot.data['level'],
                    reward: snapshot.data['devPointsRewards'],
                    isCompleted: snapshot.data['isCompleted'],
                    currentGoal: snapshot.data['currentGoal'],
                    color: AppColors.orange,
                    currentProgress: widget.user.completedMissions,
                    onTap: () async {
                      List _rewards =
                          await databaseProvider.receiveMissionReward(5);
                      showDialog(
                        context: context,
                        builder: (context) => RewardDialog(
                          devPoints: _rewards[0],
                          devCoins: _rewards[1],
                        ),
                      );
                      setup();
                    },
                    icon: Icon(
                      Icons.flag,
                      color: Colors.white,
                    ),
                  );
                }
                return EmptyCard();
              },
            ),
            SizedBox(height: 10),
            StreamBuilder<DocumentSnapshot>(
              stream: databaseProvider.getMissionById(widget.user.id, 8),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return MissionCard(
                    name: 'Colecionador',
                    desc: 'Obtenha ${snapshot.data['currentGoal']} medalhas.',
                    detailDesc:
                        'Ao utilizar o DevPush, você ganha medalhas por seus feitos gloriosos.\n\nColecione algumas medalhas para obter as recompensas!',
                    level: snapshot.data['level'],
                    reward: snapshot.data['devPointsRewards'],
                    isCompleted: snapshot.data['isCompleted'],
                    currentGoal: snapshot.data['currentGoal'],
                    color: Colors.teal,
                    currentProgress: widget.user.totalMedals,
                    onTap: () async {
                      List _rewards =
                          await databaseProvider.receiveMissionReward(8);
                      showDialog(
                        context: context,
                        builder: (context) => RewardDialog(
                          devPoints: _rewards[0],
                          devCoins: _rewards[1],
                        ),
                      );
                      setup();
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
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
