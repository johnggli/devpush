import 'package:devpush/core/app_colors.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/models/github_user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final GithubUserModel githubUser;
  final UserModel user;
  final AuthProvider authProvider;
  const ProfileScreen({
    Key key,
    @required this.githubUser,
    @required this.user,
    @required this.authProvider,
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
                      SizedBox(height: 2),
                      Text(
                        'Web developer at @caverna-labs | Programming student at IFPI - Federal Institute of Piauí.',
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
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     await widget.authProvider.logoutAction();
                      //     Navigator.pushReplacement(
                      //       context,
                      //       PageRouteBuilder(
                      //         pageBuilder: (context, animation, secondaryAnimation) =>
                      //             LoginScreen(),
                      //       ),
                      //     );
                      //   },
                      //   child: const Text('Logout'),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),

      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       ElevatedButton(
      //         onPressed: () async {
      //           await authProvider.logoutAction();
      //           Navigator.pushReplacement(
      //             context,
      //             PageRouteBuilder(
      //               pageBuilder: (context, animation, secondaryAnimation) =>
      //                   LoginScreen(),
      //             ),
      //           );
      //         },
      //         child: const Text('Logout'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
