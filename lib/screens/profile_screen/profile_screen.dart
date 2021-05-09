import 'package:devpush/components/statistic_card.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/github_provider.dart';
import 'package:devpush/screens/setting_screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/models/github_user_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:math' as math;

class ProfileScreen extends StatefulWidget {
  final GithubUserModel githubUser;
  final UserModel user;
  final GithubProvider githubProvider;
  const ProfileScreen({
    Key key,
    @required this.githubUser,
    @required this.user,
    @required this.githubProvider,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Perfil',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          if (widget.githubUser.id == widget.githubProvider.user.id)
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
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blue, width: 4),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              NetworkImage(widget.githubUser.avatarUrl ?? ''),
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
                        widget.githubUser.login,
                        // 'John Emerson',
                        style: AppTextStyles.section,
                        textAlign: TextAlign.center,
                      ),
                      if (widget.githubUser.bio != null)
                        Text(
                          widget.githubUser.bio,
                          style: AppTextStyles.description14,
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
                                'https://github.com/${widget.githubUser.login}');
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
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: StatisticCard(
                          title: 'Divisão Ranqueada',
                          color: AppColors.yellow,
                          icon: Icons.emoji_events,
                          // icon: Icons.shield,
                          description: 'Ouro',
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
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    child: Center(
                      child: Container(
                        height: 56,
                        width: 56,
                        child: Transform.rotate(
                          angle: 45 * math.pi / 180,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10), //16
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), //16
                      // color: AppColors.red,
                    ),
                    child: Center(
                      child: Icon(Icons.star),
                    ),
                  ),
                ],
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Container(color: Colors.red),
              ),
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.blue,
                ),
                child: Icon(Icons.star),
              ),
            ],
          )
        ],
      ),
    );
  }
}
