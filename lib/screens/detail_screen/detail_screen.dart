import 'package:devpush/components/reward_card.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/quiz_screen/quiz_screen.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final bool isQuiz;
  final bool isPost;
  final String quizId;
  final Map<String, dynamic> quizData;
  final String title;
  final String imageUrl;
  final String content;
  final String link;
  final String subject;
  const DetailScreen({
    Key key,
    @required this.isQuiz,
    @required this.isPost,
    this.quizId,
    this.quizData,
    this.imageUrl,
    this.title,
    this.content,
    this.link,
    this.subject,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isLoading = true;

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  Future<void> _loadData() async {
    await Provider.of<DatabaseProvider>(context, listen: false)
        .sethaveReward(widget.quizId);
  }

  @override
  void initState() {
    _loadData().then((value) => _isLoading = false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);
    var top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              expandedHeight: widget.isPost ? 180 : 232,
              floating: true,
              pinned: true,
              elevation: 1,
              backgroundColor: AppColors.black,
              brightness: Brightness.dark,
              flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                top = constraints.biggest.height;
                // print(top);
                return FlexibleSpaceBar(
                  centerTitle: true,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      FancyShimmerImage(
                        shimmerBaseColor: Colors.grey[300],
                        shimmerHighlightColor: Colors.grey[100],
                        imageUrl: widget.isQuiz
                            ? widget.quizData['quizImgUrl']
                            : widget.imageUrl,
                        boxFit: BoxFit.cover,
                        errorWidget: Image.asset(
                          AppImages.defaultImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // FadeInImage(
                      //   placeholder: AssetImage(AppImages.defaultImage),
                      //   imageErrorBuilder: (context, url, error) => Image.asset(
                      //     AppImages.defaultImage,
                      //     fit: BoxFit.cover,
                      //   ),
                      //   image: NetworkImage(
                      //     widget.isQuiz
                      //         ? widget.quizData['quizImgUrl']
                      //         : widget.imageUrl,
                      //   ),
                      //   fit: BoxFit.cover,
                      // ),
                      Opacity(
                        opacity: 0.3,
                        child: Container(
                          color: AppColors.black,
                          // decoration: BoxDecoration(
                          //   gradient: AppGradients.linearPurple,
                          // ),
                        ),
                      ),
                    ],
                  ),
                  title: widget.isPost
                      ? null
                      : top < 110.14
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                widget.isQuiz
                                    ? widget.quizData['quizTitle']
                                    : widget.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: AppTextStyles.tabTitleWhite,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                widget.isQuiz
                                    ? widget.quizData['quizTitle']
                                    : widget.title,
                                style: AppTextStyles.tabTitleWhite,
                                textAlign: TextAlign.start,
                              ),
                            ),
                );
              }),
            )
          ];
        },
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.lightGray),
                ),
              )
            : ListView(
                padding: EdgeInsets.all(18),
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Text(
                    widget.isPost
                        ? "${widget.subject}"
                        : "${widget.quizData['quizSubject']}",
                    style: AppTextStyles.blueText,
                  ),
                  if (widget.isPost)
                    Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.title,
                          style: GoogleFonts.nunito(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 12,
                  ),
                  widget.isQuiz
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.quizData['quizDesc']}",
                              style: AppTextStyles.cardTitle,
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.content,
                              style: AppTextStyles.cardTitle,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: AppColors.black,
                                  ),
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    _launchURL(widget.link);
                                  },
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Acessar',
                                          style: AppTextStyles.blackText,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          Icons.open_in_new,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  if (!widget.isPost)
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quantidade de questões',
                              style: AppTextStyles.cardTitle,
                            ),
                            Text(
                              '${widget.quizData['numberOfQuestions']}',
                              style: AppTextStyles.cardTitle,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recompensas',
                              style: AppTextStyles.cardTitle,
                            ),
                            databaseProvider.haveReward
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RewardCard(
                                        tooltip: 'DevPoints',
                                        icon: Icon(
                                          Icons.bolt,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        color: AppColors.blue,
                                        value: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      RewardCard(
                                        tooltip: 'DevCoins',
                                        icon: Icon(
                                          Icons.code,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        color: AppColors.yellow,
                                        value: 10,
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Já Obtido',
                                    style: AppTextStyles.cardTitle,
                                  ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
      ),
      floatingActionButton: widget.isPost || _isLoading
          ? null
          : FloatingActionButton.extended(
              backgroundColor: AppColors.blue,
              // foregroundColor: Colors.black,
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      quizId: widget.quizId,
                      quizData: widget.quizData,
                      haveReward: databaseProvider.haveReward,
                    ),
                  ),
                ).then((value) {
                  _loadData().then((value) => _isLoading = false);
                });
              },
              icon: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              label: Text(
                'Iniciar Quiz',
                style: AppTextStyles.label,
              ),
            ),
    );
  }
}
