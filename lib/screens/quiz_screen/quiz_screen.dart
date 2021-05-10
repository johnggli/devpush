// import 'package:devpush/screens/quiz_screen/components/question_indicator.dart';
// import 'package:devpush/screens/quiz_screen/components/quiz_widget.dart';
// import 'package:flutter/material.dart';

// class QuizScreen extends StatefulWidget {
//   final List<QuestionModel> questions;
//   final String title;
//   QuizScreen({
//     Key key,
//     @required this.questions,
//     @required this.title,
//   }) : super(key: key);

//   @override
//   _QuizScreenState createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   final controller = ChallengeController();
//   final pageController = PageController();

//   @override
//   void initState() {
//     pageController.addListener(() {
//       controller.currentPage = pageController.page.toInt() + 1;
//     });
//     super.initState();
//   }

//   void nextPage() {
//     if (controller.currentPage < widget.questions.length)
//       pageController.nextPage(
//         duration: Duration(milliseconds: 100),
//         curve: Curves.linear,
//       );
//   }

//   void onSelected(bool value) {
//     if (value) {
//       controller.qtdAnswerRight++;
//     }
//     nextPage();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(86),
//         child: SafeArea(
//           top: true,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               BackButton(),
//               ValueListenableBuilder<int>(
//                 valueListenable: controller.currentPageNotifier,
//                 builder: (context, value, _) => QuestionIndicator(
//                   currentPage: value,
//                   length: widget.questions.length,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: PageView(
//         physics: NeverScrollableScrollPhysics(),
//         controller: pageController,
//         children: widget.questions
//             .map((e) => QuizWidget(
//                   question: e,
//                   onSelected: onSelected,
//                 ))
//             .toList(),
//       ),
//       // bottomNavigationBar: SafeArea(
//       //   bottom: true,
//       //   child: Padding(
//       //     padding: const EdgeInsets.symmetric(horizontal: 20),
//       //     child: ValueListenableBuilder<int>(
//       //       valueListenable: controller.currentPageNotifier,
//       //       builder: (context, value, _) => Row(
//       //         mainAxisAlignment: MainAxisAlignment.spaceAround,
//       //         children: [
//       //           if (value < widget.questions.length)
//       //             Expanded(
//       //               child: NextButtonWidget.white(
//       //                 label: 'Pular',
//       //                 onTap: () {
//       //                   nextPage();
//       //                 },
//       //               ),
//       //             ),
//       //           if (value == widget.questions.length)
//       //             Expanded(
//       //               child: NextButtonWidget.green(
//       //                 label: 'Confirmar',
//       //                 onTap: () {
//       //                   Navigator.pushReplacement(
//       //                     context,
//       //                     MaterialPageRoute(
//       //                       builder: (context) => ResultPage(
//       //                         result: controller.qtdAnswerRight,
//       //                         title: widget.title,
//       //                         length: widget.questions.length,
//       //                       ),
//       //                     ),
//       //                   );
//       //                 },
//       //               ),
//       //             ),
//       //         ],
//       //       ),
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }
