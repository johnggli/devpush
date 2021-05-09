import 'package:devpush/core/app_text_styles.dart';
import 'package:flutter/material.dart';

class AddQuestionScreen extends StatefulWidget {
  final String quizId;

  const AddQuestionScreen({
    Key key,
    @required this.quizId,
  }) : super(key: key);

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Adicionar Questão',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
    );
  }
}
