import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/quiz_screen/quiz_screen.dart';
import 'package:flutter/material.dart';

class QuizTile extends StatelessWidget {
  final String imageUrl, title, quizId, description;
  final int numberOfQuestions;
  final DatabaseProvider databaseProvider;

  const QuizTile({
    Key key,
    @required this.imageUrl,
    @required this.title,
    @required this.quizId,
    @required this.description,
    @required this.numberOfQuestions,
    @required this.databaseProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              databaseProvider: databaseProvider,
              numberOfQuestions: numberOfQuestions,
              quizId: quizId,
              quizTitle: title,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                imageUrl.length > 0
                    ? imageUrl
                    : 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=1000',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                color: Colors.black26,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'id: $quizId',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'noOfQuestions: $numberOfQuestions',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
