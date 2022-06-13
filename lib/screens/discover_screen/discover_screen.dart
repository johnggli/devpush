import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/components/quiz_card.dart';
import 'package:devpush/components/video_card.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/discover_screen/components/highlighted.dart';
import 'package:devpush/screens/discover_screen/components/highlighted_loading.dart';
import 'package:devpush/screens/discover_screen/components/quiz_card_loading.dart';
import 'package:devpush/screens/quiz_list_screen/quiz_list_screen.dart';
import 'package:devpush/screens/video_list_screen/video_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    Key key,
  }) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  void onSelected(Widget detail) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detail),
    );
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);

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
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Em destaque',
              style: AppTextStyles.section,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: StreamBuilder<QuerySnapshot>(
              stream: databaseProvider.getHighlighted(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return HighlightedLoading();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return HighlightedLoading();
                }

                return Column(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Container(
                      width: double.maxFinite,
                      child: Highlighted(
                        label: document.data()['label'],
                        imageUrl: document.data()['imageUrl'],
                        title: document.data()['title'],
                        content: document.data()['content'],
                        link: document.data()['link'],
                        subject: document.data()['subject'],
                        onTap: (value) {
                          onSelected(value);
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quizzes',
                  style: AppTextStyles.section,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizListScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Ver tudo',
                    style: AppTextStyles.blueText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 136,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              children: [
                SizedBox(
                  width: 18,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: databaseProvider.getFixedQuizzes(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return QuizCardLoading();
                    }

                    return Row(
                      // scrollDirection: Axis.horizontal,
                      // physics: ClampingScrollPhysics(),
                      children: snapshot.data.docs
                          .map((DocumentSnapshot document) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: QuizCardLoading(),
                            );
                          })
                          .take(5)
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vídeos',
                  style: AppTextStyles.section,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoListScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Ver tudo',
                    style: AppTextStyles.blueText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 122,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              children: [
                SizedBox(
                  width: 18,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: databaseProvider.getVideos(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return Row(
                      // scrollDirection: Axis.horizontal,
                      // physics: ClampingScrollPhysics(),
                      children: snapshot.data.docs
                          .map((DocumentSnapshot document) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: VideoCard(
                                postData: {
                                  "title": document.data()['title'],
                                  "imageUrl": document.data()['imageUrl'],
                                  "link": document.data()['link'],
                                },
                                onTap: (value) {
                                  onSelected(value);
                                },
                              ),
                            );
                          })
                          .take(5)
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
