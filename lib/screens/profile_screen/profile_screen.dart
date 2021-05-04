import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/models/github_user_model.dart';
import 'package:devpush/providers/auth_provider.dart';
import 'package:devpush/screens/login_screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final GithubUserModel githubUser;
  const ProfileScreen({
    Key key,
    @required this.githubUser,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      body: Row(
        children: [
          Column(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blue, width: 4),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.githubUser.avatarUrl ?? ''),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
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
