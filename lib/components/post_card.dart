import 'package:devpush/core/app_colors.dart';
import 'package:devpush/models/github_user_model.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/providers/github_provider.dart';
import 'package:devpush/screens/profile_screen/profile_screen.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final int userId;
  final String postUserName;
  final String postProfilePicture;
  final String postDateTime;
  const PostCard({
    Key key,
    @required this.userId,
    @required this.postUserName,
    @required this.postProfilePicture,
    @required this.postDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);
    var githubProvider = Provider.of<GithubProvider>(context);

    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

    final difference = DateTime.parse(postDateTime);

    return Container(
      height: 200,
      width: 264,
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
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ClipOval(
                child: Container(
                  height: 48,
                  width: 48,
                  child: FancyShimmerImage(
                    shimmerBaseColor: Colors.grey[300],
                    shimmerHighlightColor: Colors.grey[100],
                    imageUrl: postProfilePicture,
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Text(timeago.format(difference, locale: 'pt_BR')),
          ),
          TextButton(
            onPressed: () async {
              GithubUserModel _githubUser;
              UserModel _user;

              Future<void> setUser() async {
                _githubUser =
                    await githubProvider.getGithubUserModelById(userId);
                _user = await databaseProvider.getUserModelById(userId);
              }

              setUser().then(
                (_) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      githubUser: _githubUser,
                      user: _user,
                    ),
                  ),
                ),
              );
            },
            child: Text('ir pro perfil'),
          ),
        ],
      ),
    );
  }
}
