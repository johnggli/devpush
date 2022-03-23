import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/profile_screen/profile_screen.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final int userId;
  final String postId;
  final String postUserName;
  final String postProfilePicture;
  final String createdAt;
  final String postContent;
  final int postPoints;
  const PostCard({
    Key key,
    @required this.userId,
    @required this.postId,
    @required this.postUserName,
    @required this.postProfilePicture,
    @required this.createdAt,
    @required this.postContent,
    @required this.postPoints,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

    final difference = DateTime.parse(widget.createdAt);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });

                        UserModel _user;

                        Future<void> setUser() async {
                          _user = await databaseProvider
                              .getUserModelById(widget.userId);
                        }

                        setUser().then((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                user: _user,
                              ),
                            ),
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 18,
                        left: 18,
                        right: 12,
                        bottom: 12,
                      ),
                      child: Column(
                        children: [
                          ClipOval(
                            child: Container(
                              height: 40,
                              width: 40,
                              child: FancyShimmerImage(
                                shimmerBaseColor: Colors.grey[300],
                                shimmerHighlightColor: Colors.grey[100],
                                imageUrl: widget.postProfilePicture,
                              ),
                            ),
                          ),
                        ],
                      ),
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
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
                        color: Colors.white,
                        child: PopupMenuButton<String>(
                          onSelected: (String result) {
                            if (result == 'Compartilhar') {
                              Share.share(
                                  'DevPush\nPostagem de ${widget.postUserName}:\n${widget.postContent}');
                            }
                            if (result == 'Reportar') {
                              String _reason = '';
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Reportar Postagem'),
                                  content: TextField(
                                    onChanged: (value) {
                                      _reason = value;
                                    },
                                    decoration:
                                        InputDecoration(hintText: "Motivo"),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (_reason.isNotEmpty) {
                                          await databaseProvider.reportPost(
                                              widget.postId, _reason);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Postagem reportada!',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text('Enviar'),
                                    ),
                                  ],
                                ),
                              );
                            }
                            if (result == 'Excluir') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Tem Certeza?'),
                                  content:
                                      Text('Deseja excluir esta postagem?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Future<void> deletePost() async {
                                          await databaseProvider
                                              .deletePost(widget.postId);
                                        }

                                        deletePost().then((_) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Postagem excluída!',
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      child: Text('Sim'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Compartilhar',
                              child: Text('Compartilhar'),
                            ),
                            widget.userId == databaseProvider.userId
                                ? const PopupMenuItem<String>(
                                    value: 'Excluir',
                                    child: Text(
                                      'Excluir',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  )
                                : const PopupMenuItem<String>(
                                    value: 'Reportar',
                                    child: Text('Reportar'),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 6,
              left: 18,
              right: 18,
              bottom: 12,
            ),
            child: ReadMoreText(
              widget.postContent,
              style: AppTextStyles.cardBody,
              trimLines: 5,
              trimMode: TrimMode.Line,
              trimCollapsedText: '\nLer mais',
              trimExpandedText: '',
              moreStyle: AppTextStyles.blueText,
              lessStyle: AppTextStyles.blueText,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 18,
              right: 18,
              bottom: 18,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.userId != databaseProvider.userId
                    ? Row(
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: databaseProvider
                                .getUserLikedPostById(widget.postId),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.exists) {
                                  return Icon(
                                    Icons.favorite,
                                    size: 28,
                                    color: Colors.redAccent,
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: () async {
                                      await databaseProvider.likePost(
                                          widget.postId, widget.userId);
                                    },
                                    child: Icon(
                                      Icons.favorite_border,
                                      size: 28,
                                      color: AppColors.gray,
                                    ),
                                  );
                                }
                              }
                              return Icon(
                                Icons.favorite_border,
                                size: 28,
                                color: AppColors.gray,
                              );
                            },
                          ),
                        ],
                      )
                    : Container(),
                Text(
                  '${widget.postPoints} Pontos',
                  style: AppTextStyles.cardSubTitle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
