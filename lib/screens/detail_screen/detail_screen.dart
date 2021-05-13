import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/quiz_screen/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final String quizId;
  final Map<String, dynamic> quizData;
  final bool isOnlyQuiz;
  final String title;
  final String imageUrl;
  final String content;
  final String link;
  const DetailScreen({
    Key key,
    @required this.quizId,
    @required this.quizData,
    @required this.isOnlyQuiz,
    this.imageUrl,
    this.title,
    this.content,
    this.link,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  void initState() {
    Provider.of<DatabaseProvider>(context, listen: false)
        .sethaveReward(widget.quizId);
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
              expandedHeight: 232,
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
                      FadeInImage(
                        placeholder: AssetImage(AppImages.defaultImage),
                        imageErrorBuilder: (context, url, error) => Image.asset(
                          AppImages.defaultImage,
                          fit: BoxFit.cover,
                        ),
                        image: NetworkImage(widget.isOnlyQuiz
                            ? widget.quizData['quizImgUrl']
                            : widget.imageUrl),
                        fit: BoxFit.cover,
                      ),
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
                  title: top < 110.14
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            widget.isOnlyQuiz
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
                            widget.isOnlyQuiz
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
        body: ListView(
          padding: EdgeInsets.all(18),
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Text(
              "${widget.quizData['quizSubject']}",
              style: AppTextStyles.blueText,
            ),
            SizedBox(
              height: 18,
            ),
            widget.isOnlyQuiz
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
                              child: Center(
                                child: Text(
                                  'Acessar',
                                  style: AppTextStyles.blackText,
                                ),
                              ),
                            ),
                          ),
                        ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recompensas',
                  style: AppTextStyles.cardTitle,
                ),
                databaseProvider.haveReward
                    ? Row(
                        children: [
                          Text(
                            '+30',
                            style: AppTextStyles.cardTitle,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            '+10',
                            style: AppTextStyles.cardTitle,
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.blue,
        // foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(
                quizId: widget.quizId,
                quizData: widget.quizData,
                haveReward: databaseProvider.haveReward,
              ),
            ),
          );
        },
        icon: Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        label: Text(
          'INICIAR QUIZ',
          style: AppTextStyles.label,
        ),
      ),
    );
  }
}
