import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/components/achievements_card.dart';
import 'package:devpush/components/statistic_card.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/profile_screen/components/empty_achievement_card.dart';
import 'package:devpush/screens/profile_screen/components/ranking_screen.dart';
import 'package:devpush/screens/setting_screen/setting_screen.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  const ProfileScreen({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  void initState() {
    Provider.of<DatabaseProvider>(context, listen: false).updateRank();
    Provider.of<DatabaseProvider>(context, listen: false).updateProviderUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.lightGray,
        ),
        centerTitle: true,
        title: Text(
          'Perfil',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          if (widget.user.id == databaseProvider.user.id)
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingScreen(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.settings,
                    size: 26.0,
                    color: AppColors.lightGray,
                  ),
                )),
        ],
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 18,
              bottom: 10,
              left: 18,
              right: 18,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ClipOval(
                      child: Container(
                        height: 96,
                        width: 96,
                        child: FancyShimmerImage(
                          shimmerBaseColor: Colors.grey[300],
                          shimmerHighlightColor: Colors.grey[100],
                          imageUrl: widget.user.avatarUrl,
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Level ${widget.user.level}',
                      style: AppTextStyles.subHead,
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
                        widget.user.login,
                        style: GoogleFonts.nunito(
                          color: AppColors.dark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      if (widget.user.bio != null)
                        Text(
                          widget.user.bio,
                          style: AppTextStyles.description14,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      SizedBox(height: 10),
                      Container(
                        height: 32,
                        width: 124,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(AppColors.blue),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            // side: MaterialStateProperty.all(BorderSide(color: borderColor)),
                          ),
                          onPressed: () {
                            _launchURL(
                                'https://github.com/${widget.user.login}');
                          },
                          child: Text(
                            'Ver no Github',
                            style: AppTextStyles.whiteText,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              'Estatísticas',
              style: AppTextStyles.section,
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: StatisticCard(
                          title: 'Missões Completadas',
                          color: AppColors.green,
                          icon: Icons.check,
                          description: '14',
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: StatisticCard(
                          title: 'Dias de Ofensiva',
                          color: AppColors.red,
                          icon: Icons.local_fire_department,
                          description: '12',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: StatisticCard(
                          title: 'Total de DevPoints',
                          color: AppColors.blue,
                          icon: Icons.bolt,
                          description: '1.470',
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: StatisticCard(
                          title: 'Posição no Ranque',
                          color: AppColors.yellow,
                          icon: Icons.emoji_events,
                          // icon: Icons.shield,
                          description: widget.user.rank > 0
                              ? '${widget.user.rank}º'
                              : '',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RankingScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              'Conquistas',
              style: AppTextStyles.section,
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                      // legendary
                      stream:
                          databaseProvider.getMissionById(widget.user.id, 1),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return AchievementsCard(
                            color: AppColors.green,
                            icon: Icons.auto_awesome,
                            level: snapshot.data['level'],
                          );
                        }
                        return EmptyAchievementCard();
                      },
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      // legendary
                      stream:
                          databaseProvider.getMissionById(widget.user.id, 2),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return AchievementsCard(
                            color: AppColors.red,
                            icon: Icons.local_fire_department,
                            level: snapshot.data['level'],
                          );
                        }
                        return EmptyAchievementCard();
                      },
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      // legendary
                      stream:
                          databaseProvider.getMissionById(widget.user.id, 6),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return AchievementsCard(
                            color: AppColors.blue,
                            icon: Icons.library_add,
                            level: snapshot.data['level'],
                          );
                        }
                        return EmptyAchievementCard();
                      },
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      // legendary
                      stream:
                          databaseProvider.getMissionById(widget.user.id, 3),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return AchievementsCard(
                            color: AppColors.purple,
                            icon: Icons.verified_user,
                            level: snapshot.data['level'],
                          );
                        }
                        return EmptyAchievementCard();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                      // legendary
                      stream:
                          databaseProvider.getMissionById(widget.user.id, 7),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return AchievementsCard(
                            color: AppColors.pink,
                            icon: Icons.favorite,
                            level: snapshot.data['level'],
                          );
                        }
                        return EmptyAchievementCard();
                      },
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      // legendary
                      stream:
                          databaseProvider.getMissionById(widget.user.id, 4),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return AchievementsCard(
                            color: AppColors.gray,
                            icon: Icons.group_add,
                            level: snapshot.data['level'],
                          );
                        }
                        return EmptyAchievementCard();
                      },
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      // legendary
                      stream:
                          databaseProvider.getMissionById(widget.user.id, 5),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return AchievementsCard(
                            color: AppColors.yellow,
                            icon: Icons.military_tech,
                            level: snapshot.data['level'],
                          );
                        }
                        return EmptyAchievementCard();
                      },
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      // legendary
                      stream:
                          databaseProvider.getMissionById(widget.user.id, 8),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return AchievementsCard(
                            color: AppColors.teal,
                            icon: Icons.self_improvement,
                            level: snapshot.data['level'],
                          );
                        }
                        return EmptyAchievementCard();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
