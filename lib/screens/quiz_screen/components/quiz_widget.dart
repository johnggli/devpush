import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/screens/quiz_screen/components/answer_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final String correctOption;
  final ValueChanged<bool> onSelected;
  const QuizWidget({
    Key key,
    @required this.question,
    @required this.options,
    @required this.correctOption,
    @required this.onSelected,
  }) : super(key: key);

  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int indexSelected = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 48,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              widget.question,
              style: GoogleFonts.nunito(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          // for (var i = 0; i < widget.question.answers.length; i++)
          for (var i = 0; i < 4; i++)
            AnswerWidget(
              option: widget.options[i],
              correctOption: widget.correctOption,
              disabled: indexSelected != -1,
              isSelected: indexSelected == i,
              onTap: (value) {
                indexSelected = i;

                setState(() {});
                Future.delayed(Duration(seconds: 1))
                    .then((_) => widget.onSelected(value));
              },
            ),
          SizedBox(
            height: 64,
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
