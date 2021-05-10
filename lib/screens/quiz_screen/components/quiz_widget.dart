// import 'package:devpush/core/app_text_styles.dart';
// import 'package:devpush/screens/quiz_screen/components/answer_widget.dart';
// import 'package:flutter/material.dart';

// class QuizWidget extends StatefulWidget {
//   final QuestionModel question;
//   final ValueChanged<bool> onSelected;
//   const QuizWidget({
//     Key key,
//     @required this.question,
//     @required this.onSelected,
//   }) : super(key: key);

//   @override
//   _QuizWidgetState createState() => _QuizWidgetState();
// }

// class _QuizWidgetState extends State<QuizWidget> {
//   int indexSelected = -1;

//   AnswerModel answer(int index) => widget.question.answers[index];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           SizedBox(
//             height: 64,
//           ),
//           Text(
//             widget.question.title,
//             style: AppTextStyles.title,
//           ),
//           SizedBox(
//             height: 24,
//           ),
//           for (var i = 0; i < widget.question.answers.length; i++)
//             AnswerWidget(
//               answer: answer(i),
//               disabled: indexSelected != -1,
//               isSelected: indexSelected == i,
//               onTap: (value) {
//                 indexSelected = i;

//                 setState(() {});
//                 Future.delayed(Duration(seconds: 1))
//                     .then((_) => widget.onSelected(value));
//               },
//             ),

//           // ...widget.question.answers
//           //     .map(
//           //       (e) => AnswerWidget(
//           //         title: e.title,
//           //         isRight: e.isRight,
//           //       ),
//           //     )
//           //     .toList(),
//         ],
//       ),
//     );
//   }
// }
