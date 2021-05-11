import 'package:devpush/screens/test_screen/components/result.dart';
import 'package:devpush/screens/test_screen/components/test.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  const TestScreen({
    Key key,
    @required this.questions,
  }) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;

    setState(() {
      _questionIndex = _questionIndex + 1;
    });
    print(_questionIndex);
    if (_questionIndex < widget.questions.length) {
      print('We have more questions!');
    } else {
      print('No more questions!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geeks for Geeks'),
        backgroundColor: Color(0xFF00E676),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: _questionIndex < widget.questions.length
            ? Test(
                answerQuestion: _answerQuestion,
                questionIndex: _questionIndex,
                questions: widget.questions,
              )
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
