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

  int _minQuestions = 4;
  List<Map<String, String>> _quizQuestions = [];

  bool _isLoading = false;

  String question = '';
  String option1 = '';
  String option2 = '';
  String option3 = '';
  String option4 = '';

  void addQuestion() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };

      _quizQuestions.add(questionMap);
      _formKey.currentState.reset();

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> createQuiz() async {
    widget.quizData['numberOfQuestions'] = _quizQuestions.length;

    Provider.of<DatabaseProvider>(context, listen: false)
        .addQuizData(widget.quizData, widget.quizId);

    _quizQuestions.forEach((question) {
      Provider.of<DatabaseProvider>(context, listen: false)
          .addQuizQuestion(question, widget.quizId);
    });
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
      body: _isLoading
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
                        textCapitalization: TextCapitalization.sentences,
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
                        textCapitalization: TextCapitalization.sentences,
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
                        textCapitalization: TextCapitalization.sentences,
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
                        textCapitalization: TextCapitalization.sentences,
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
                        textCapitalization: TextCapitalization.sentences,
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
                              onTap: addQuestion,
                            ),
                          ),
                          if (_quizQuestions.length >= _minQuestions)
                            SizedBox(
                              width: 12,
                            ),
                          if (_quizQuestions.length >= _minQuestions)
                            Expanded(
                              child: SimpleButton(
                                color: AppColors.green,
                                title: 'Finalizar',
                                onTap: () async {
                                  await createQuiz();
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
