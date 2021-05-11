import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/screens/quiz_list_screen/quiz_list_screen.dart';
import 'package:devpush/screens/test_screen/test_screen.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    Key key,
  }) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Descobrir',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Em destaque',
              style: AppTextStyles.section,
            ),
          ),
          SizedBox(height: 18),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizListScreen(),
                ),
              );
            },
            child: Text('Questionários'),
          ),
          SizedBox(height: 18),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestScreen(),
                ),
              );
            },
            child: Text('github exam'),
          ),
        ],
      ),
    );
  }
}
