import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/models/github_user_model.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/providers/github_provider.dart';
import 'package:devpush/screens/profile_screen/profile_screen.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final int userId;
  final String postUserName;
  final String postProfilePicture;
  final String postDateTime;
  final String postContent;
  final int postPoints;
  const PostCard({
    Key key,
    @required this.userId,
    @required this.postUserName,
    @required this.postProfilePicture,
    @required this.postDateTime,
    @required this.postContent,
    @required this.postPoints,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLoading = false;
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);
    var githubProvider = Provider.of<GithubProvider>(context);

    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

    final difference = DateTime.parse(widget.postDateTime);

    return Container(
      // height: 200,
      // width: 264,
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            color: AppColors.light,
          ),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
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
                          imageUrl: widget.postProfilePicture,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.postUserName,
                      style: AppTextStyles.cardTitle,
                    ),
                    Text(
                      timeago.format(difference, locale: 'pt_BR'),
                      style: AppTextStyles.description12,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              widget.postContent,
              style: AppTextStyles.cardBody,
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.postPoints} Pontos',
                  style: AppTextStyles.cardTitle,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _liked = !_liked;
                        });
                      },
                      child: _liked
                          ? Icon(
                              Icons.favorite,
                              size: 28,
                              color: AppColors.red,
                            )
                          : Icon(
                              Icons.favorite_border,
                              size: 28,
                              color: AppColors.gray,
                            ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    _isLoading
                        ? Container(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.lightGray),
                            ),
                          )
                        : Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                GithubUserModel _githubUser;
                                UserModel _user;

                                Future<void> setUser() async {
                                  _githubUser = await githubProvider
                                      .getGithubUserModelById(widget.userId);
                                  _user = await databaseProvider
                                      .getUserModelById(widget.userId);
                                }

                                setUser().then((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        githubUser: _githubUser,
                                        user: _user,
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              },
                              child: Icon(
                                Icons.person,
                                size: 28,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
