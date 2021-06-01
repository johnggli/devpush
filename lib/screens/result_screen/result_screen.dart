import 'package:devpush/components/reward_card.dart';
import 'package:devpush/components/simple_button.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:flutter/material.dart';
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
        Provider.of<DatabaseProvider>(context, listen: false)
            .addRatedQuiz(widget.quizId, 5);
      }
      if (widget.result == widget.quizData['numberOfQuestions']) {
        Provider.of<DatabaseProvider>(context, listen: false).addWin();
      }
    }
    super.initState();
  }

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
                            print('clicou');
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
