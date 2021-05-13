import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/quiz_screen/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          padding: EdgeInsets.only(top: 0),
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            widget.isOnlyQuiz
                ? Column(
                    children: [
                      Text("titulo do quiz: ${widget.quizData['quizTitle']}"),
                      Text("descrição: ${widget.quizData['quizDesc']}"),
                    ],
                  )
                : Column(
                    children: [
                      Text("titulo do highlighted: ${widget.title}"),
                      Text("conteudo: ${widget.content}"),
                      Text("link: ${widget.link}"),
                    ],
                  ),
            TextButton(
              onPressed: () async {
                await databaseProvider.sethaveReward(widget.quizId).then((_) {
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
                });
              },
              child: Text('ir pro quizzzz'),
            )
            // FutureBuilder<DocumentSnapshot>(
            //   future: databaseProvider.getQuizById(widget.quizId),
            //   builder: (BuildContext context,
            //       AsyncSnapshot<DocumentSnapshot> snapshot) {
            //     if (snapshot.hasError) {
            //       return Text("Something went wrong");
            //     }

            //     if (snapshot.hasData && !snapshot.data.exists) {
            //       return Text("Document does not exist");
            //     }

            //     if (snapshot.connectionState == ConnectionState.done) {
            //       Map<String, dynamic> data = snapshot.data.data();
            //       return QuizCard(
            //         quizId: widget.quizId,
            //         quizData: {
            //           "userId": data['userId'],
            //           "quizImgUrl": data['quizImgUrl'],
            //           "quizTitle": data['quizTitle'],
            //           "quizSubject": data['quizSubject'],
            //           "numberOfQuestions": data['numberOfQuestions'],
            //         },
            //       );
            //     }

            //     return Text("loading");
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
