import 'package:devpush/components/reward_card.dart';
import 'package:devpush/components/simple_button.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatefulWidget {
  final String quizId;
  final Map<String, dynamic> quizData;
  final int result;
  final bool haveReward;
  const ResultScreen({
    Key key,
    @required this.quizId,
    @required this.quizData,
    @required this.result,
    @required this.haveReward,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    if (widget.haveReward) {
      if (widget.result / widget.quizData['numberOfQuestions'] > 0.7) {
        Provider.of<DatabaseProvider>(context, listen: false).receiveReward();
        Provider.of<DatabaseProvider>(context, listen: false)
            .addUserSolvedQuiz(widget.quizData, widget.quizId);
      }
      if (widget.result == widget.quizData['numberOfQuestions']) {
        Provider.of<DatabaseProvider>(context, listen: false).addWin();
      }
    }
    super.initState();
  }

  int _rating = 3;

  @override
  Widget build(BuildContext context) {
    bool approved = widget.result / widget.quizData['numberOfQuestions'] > 0.7;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: AppColors.lightGray,
              size: 36,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(top: 18),
            child: !approved
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Image.asset(
                          AppImages.error,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Que pena! :(',
                            style: AppTextStyles.heading40,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Você não obteve nota acima de 70% em',
                              style: AppTextStyles.body,
                              children: [
                                TextSpan(
                                  text: '\n${widget.quizData['quizTitle']}',
                                  style: AppTextStyles.blackText,
                                ),
                                TextSpan(
                                  text:
                                      '\nAcertou ${widget.result} de ${widget.quizData['numberOfQuestions']} questões.',
                                  style: AppTextStyles.body,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: 236,
                        child: SimpleButton(
                          color: AppColors.blue,
                          title: 'Tentar Novamente',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  )
                : Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Image.asset(
                          AppImages.trophy,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Column(
                        children: [
                          Text(
                            'Parabéns!',
                            style: AppTextStyles.heading40,
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Você concluiu',
                              style: AppTextStyles.body,
                              children: [
                                TextSpan(
                                  text: '\n${widget.quizData['quizTitle']}',
                                  style: AppTextStyles.blackText,
                                ),
                                TextSpan(
                                  text:
                                      '\nAcertou ${widget.result} de ${widget.quizData['numberOfQuestions']} questões!',
                                  style: AppTextStyles.body,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Recompensas:',
                        style: AppTextStyles.blueText,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        child: Row(
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
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: 236,
                        child: SimpleButton(
                          color: AppColors.green,
                          title: 'Compartilhar Resutado',
                          onTap: () {
                            Share.share(
                                'DevPush: Resultado do Quiz: ${widget.quizData['quizTitle']}\nAcertei ${widget.result} de ${widget.quizData['numberOfQuestions']} questões!');
                          },
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Container(
                        width: 236,
                        child: SimpleButton(
                          color: AppColors.blue,
                          title: 'Avaliar Quiz',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0.0,
                                backgroundColor: Colors.transparent,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(
                                        top: 44,
                                        bottom: 16,
                                        left: 16,
                                        right: 16,
                                      ),
                                      margin: EdgeInsets.only(top: 28),
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10.0,
                                            offset: const Offset(0.0, 10.0),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize
                                            .min, // To make the card compact
                                        children: <Widget>[
                                          Text(
                                            'Avaliar Quiz',
                                            style: AppTextStyles.title,
                                          ),
                                          SizedBox(height: 16.0),
                                          Text(
                                            'Toque em uma estrela para definir sua avaliação.',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.cardBody,
                                          ),
                                          SizedBox(height: 16.0),
                                          RatingBar.builder(
                                            initialRating: 3,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: AppColors.yellow,
                                            ),
                                            onRatingUpdate: (rating) {
                                              setState(() {
                                                _rating = rating.toInt();
                                              });
                                            },
                                          ),
                                          SizedBox(height: 24.0),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: TextButton(
                                              onPressed: () {
                                                Provider.of<DatabaseProvider>(
                                                        context,
                                                        listen: false)
                                                    .addRatedQuiz(
                                                        widget.quizId, _rating);
                                                Navigator.of(context)
                                                    .pop(); // To close the dialog
                                              },
                                              child: Text('Enviar'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 16,
                                      right: 16,
                                      child: CircleAvatar(
                                        backgroundColor: AppColors.yellow,
                                        radius: 28,
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 36,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
