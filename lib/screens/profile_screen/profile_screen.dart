import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/components/achievements_card.dart';
import 'package:devpush/components/statistic_card.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/profile_screen/components/empty_achievement_card.dart';
import 'package:devpush/screens/profile_screen/components/medal_card.dart';
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

  String dateFormat(String date) {
    String onlyDate = date.split(' ')[0];
    String day = onlyDate.split('-')[2];
    String mounth = onlyDate.split('-')[1];
    String year = onlyDate.split('-')[0];
    return '$day/$mounth/$year';
  }

  @override
  void initState() {
    Provider.of<DatabaseProvider>(context, listen: false).updateRank();
    // Future.delayed(
    //     Duration.zero,
    //     () => Provider.of<DatabaseProvider>(context, listen: false)
    //         .setMedalNotification(false));

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
          widget.user.visitCard.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: NetworkImage(widget.user.visitCard),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.9),
                        BlendMode.dstATop,
                      ),
                    ),
                  ),
                  child: Column(
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
                                      boxFit: BoxFit.cover,
                                      errorWidget: Image.asset(
                                        AppImages.defaultImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Level ${widget.user.level}',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    // shadows: <Shadow>[
                                    //   Shadow(
                                    //     offset: Offset(1, 1),
                                    //     blurRadius: 24,
                                    //     color: Colors.grey,
                                    //   ),
                                    // ],
                                  ),
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
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      // shadows: <Shadow>[
                                      //   Shadow(
                                      //     offset: Offset(1, 1),
                                      //     blurRadius: 24,
                                      //     color: Colors.grey,
                                      //   ),
                                      // ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                  ),
                                  if (widget.user.bio != null)
                                    Text(
                                      widget.user.bio,
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                        // shadows: <Shadow>[
                                        //   Shadow(
                                        //     offset: Offset(1, 1),
                                        //     blurRadius: 24,
                                        //     color: Colors.grey,
                                        //   ),
                                        // ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 32,
                                    width: 112,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        // backgroundColor:
                                        //     MaterialStateProperty.all(
                                        //         AppColors.blue),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            side: BorderSide(
                                              width: 2,
                                              color: Colors.white,
                                            ),
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  child: Column(
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
                                      boxFit: BoxFit.cover,
                                      errorWidget: Image.asset(
                                        AppImages.defaultImage,
                                        fit: BoxFit.cover,
                                      ),
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
                                    width: 112,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        // backgroundColor:
                                        //     MaterialStateProperty.all(
                                        //         AppColors.blue),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            side: BorderSide(
                                              width: 2,
                                              color: AppColors.blue,
                                            ),
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
                                        style: AppTextStyles.blueLabel,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          widget.user.visitCard.isNotEmpty
              ? SizedBox(
                  height: 16,
                )
              : Divider(
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
                          description: '${widget.user.completedMissions}',
                          // onTap: () {},
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
                          description: '${widget.user.loginStreak}',
                          // onTap: () {},
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
                          description: '${widget.user.devPoints}',
                          // onTap: () {},
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RankingScreen(),
                              ),
                            );
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: StatisticCard(
                            title: 'Posição no Ranque',
                            color: AppColors.yellow,
                            icon: Icons.emoji_events,
                            // icon: Icons.shield,
                            description: widget.user.rank > 0
                                ? '${widget.user.rank}º'
                                : '',
                          ),
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
                            color: Colors.redAccent,
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
                            color: Colors.blueAccent,
                            icon: Icons.school,
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
                            icon: Icons.volunteer_activism,
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
                            color: AppColors.yellow,
                            icon: Icons.star,
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
                            color: AppColors.orange,
                            icon: Icons.flag,
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
                            color: Colors.teal,
                            icon: Icons.military_tech,
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
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Medalhas',
                  style: AppTextStyles.section,
                ),
                // TextButton(
                //   onPressed: () {
                //     // Navigator.push(
                //     //   context,
                //     //   MaterialPageRoute(
                //     //     builder: (context) => QuizListScreen(),
                //     //   ),
                //     // );
                //   },
                //   child: Text(
                //     'Ver todas',
                //     style: AppTextStyles.blueText,
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream: databaseProvider.getUserMedals(widget.user.id),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              if (snapshot.data.size == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      Icon(
                        Icons.military_tech,
                        color: Colors.grey[400],
                        size: MediaQuery.of(context).size.width * 0.08,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Sem medalhas ainda.",
                        style: GoogleFonts.nunito(
                          color: Colors.grey[400],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2 / 2.8,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                primary: false,
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return MedalCard(
                    kind: snapshot.data.docs[index].data()['kind'],
                    medalId: snapshot.data.docs[index].data()['medalId'],
                    date: dateFormat(snapshot.data.docs[index].data()['date']),
                  );
                },
              );
            },
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
