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
      Provider.of<DatabaseProvider>(context, listen: false).receiveReward();
      Provider.of<DatabaseProvider>(context, listen: false)
          .addUserSolvedQuiz(widget.quizData, widget.quizId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset(
                AppImages.trophy,
              ),
            ),
            Column(
              children: [
                Text(
                  'Parabéns!',
                  style: AppTextStyles.heading40,
                ),
                SizedBox(
                  height: 16,
                ),
                Text.rich(
                  TextSpan(
                    text: 'Você concluiu',
                    style: AppTextStyles.body,
                    children: [
                      TextSpan(
                        text: '\n${widget.quizData['quizTitle']}',
                        style: AppTextStyles.bodyBold,
                      ),
                      TextSpan(
                        text:
                            '\ncom ${widget.result} de ${widget.quizData['numberOfQuestions']} acertos.',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 68),
                        child: GestureDetector(
                          onTap: () {
                            Share.share(
                                'DevPush: Resultado do Quiz: ${widget.quizData['quizTitle']}\nAcertei ${widget.result} de ${widget.quizData['numberOfQuestions']} questões!');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: 310,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Compartilhar',
                                style: AppTextStyles.label,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 68),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: 310,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Voltar aos quizzes',
                                style: AppTextStyles.label,
                              ),
                            ),
                          ),
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
