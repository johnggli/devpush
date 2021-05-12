import 'package:devpush/components/simple_button.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddQuestionScreen extends StatefulWidget {
  final String quizId;
  final Map<String, dynamic> quizData;
  const AddQuestionScreen({
    Key key,
    @required this.quizId,
    @required this.quizData,
  }) : super(key: key);

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String question = '';
  String option1 = '';
  String option2 = '';
  String option3 = '';
  String option4 = '';

  int numberOfQuestions = 0;

  void uploadQuizData() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };

      numberOfQuestions++;

      Provider.of<DatabaseProvider>(context, listen: false)
          .addQuizData(widget.quizData, widget.quizId);

      Provider.of<DatabaseProvider>(context, listen: false)
          .addQuizQuestion(questionMap, numberOfQuestions, widget.quizId)
          .then((value) {
        question = "";
        option1 = "";
        option2 = "";
        option3 = "";
        option4 = "";

        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        print(e);
      });
    } else {
      print("error is happening");
    }
  }

  isValid(String string) {
    if (string.isEmpty) {
      return 'vazio';
    }

    int count = 0;
    List<String> strings = [
      option1?.toLowerCase(),
      option2?.toLowerCase(),
      option3?.toLowerCase(),
      option4?.toLowerCase(),
    ];

    for (int i = 0; i < strings.length; i++) {
      if (string?.toLowerCase() == strings[i]) {
        count++;
      }
    }
    if (count > 1) {
      return 'ja existe';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.lightGray,
        ),
        centerTitle: true,
        title: Text(
          'Adicionar Questão',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightGray),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: ListView(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? 'Escreva um título' : null,
                        decoration: InputDecoration(hintText: 'Questão'),
                        onChanged: (val) {
                          question = val;
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        validator: (val) => isValid(val),
                        decoration: InputDecoration(
                            hintText: 'Opção 1 (resposta correta)'),
                        onChanged: (val) {
                          option1 = val;
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        validator: (val) => isValid(val),
                        decoration: InputDecoration(hintText: 'Opção 2'),
                        onChanged: (val) {
                          option2 = val;
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        validator: (val) => isValid(val),
                        decoration: InputDecoration(hintText: 'Opção 3'),
                        onChanged: (val) {
                          option3 = val;
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        validator: (val) => isValid(val),
                        decoration: InputDecoration(hintText: 'Opção 4'),
                        onChanged: (val) {
                          option4 = val;
                        },
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SimpleButton(
                              color: AppColors.blue,
                              title: 'Adicionar Questão',
                              onTap: uploadQuizData,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: SimpleButton(
                              color: AppColors.gray,
                              title: 'Finalizar',
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
