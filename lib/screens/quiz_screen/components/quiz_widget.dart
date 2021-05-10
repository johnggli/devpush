import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/screens/quiz_screen/components/answer_widget.dart';
import 'package:flutter/material.dart';

class QuizWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final ValueChanged<bool> onSelected;
  const QuizWidget({
    Key key,
    @required this.question,
    @required this.options,
    @required this.onSelected,
  }) : super(key: key);

  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int indexSelected = -1;
  List<String> options;

  @override
  void initState() {
    options = widget.options..shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 64,
          ),
          Text(
            widget.question,
            style: AppTextStyles.title,
          ),
          SizedBox(
            height: 24,
          ),
          // for (var i = 0; i < widget.question.answers.length; i++)
          for (var i = 0; i < 4; i++)
            AnswerWidget(
              option: options[i],
              correctOption: widget.options[0],
              disabled: indexSelected != -1,
              isSelected: indexSelected == i,
              onTap: (value) {
                indexSelected = i;

                setState(() {});
                Future.delayed(Duration(seconds: 1))
                    .then((_) => widget.onSelected(value));
              },
            ),

          // ...widget.question.answers
          //     .map(
          //       (e) => AnswerWidget(
          //         title: e.title,
          //         isRight: e.isRight,
          //       ),
          //     )
          //     .toList(),
        ],
      ),
    );
  }
}
