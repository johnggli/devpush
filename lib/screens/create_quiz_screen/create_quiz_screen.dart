import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/screens/add_question_screen/add_questions_screen.dart';
import 'package:devpush/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class CreateQuizScreen extends StatefulWidget {
  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String quizImgUrl = '';
  String quizTitle = '';
  String quizDesc = '';

  bool isLoading = false;
  String quizId;

  void createQuiz() {
    quizId = randomAlphaNumeric(16);
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "quizImgUrl": quizImgUrl,
        "quizTitle": quizTitle,
        "quizDesc": quizDesc
      };

      databaseService.addQuizData(quizData, quizId).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddQuestionScreen(
              quizId: quizId,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Criar Quiz',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                // validator: (val) => val.isEmpty ? "Enter Quiz Image Url" : null,
                decoration:
                    InputDecoration(hintText: "Quiz Image Url (Optional)"),
                onChanged: (val) {
                  quizImgUrl = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter Quiz Title" : null,
                decoration: InputDecoration(hintText: "Quiz Title"),
                onChanged: (val) {
                  quizTitle = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ? "Enter Quiz Description" : null,
                decoration: InputDecoration(hintText: "Quiz Description"),
                onChanged: (val) {
                  quizDesc = val;
                },
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  createQuiz();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Create Quiz",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
