import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/components/video_card.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({
    Key key,
  }) : super(key: key);

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  void onSelected(Widget detail) {
    Future.delayed(Duration(milliseconds: 200)).then(
      (_) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => detail),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.lightGray,
        ),
        centerTitle: true,
        title: Text(
          'Vídeos',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: databaseProvider.getVideos(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            physics: ClampingScrollPhysics(),
            children: [
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        width: double.maxFinite,
                        child: VideoCard(
                          postData: {
                            "title": document.data()['title'],
                            "imageUrl": document.data()['imageUrl'],
                            "content": document.data()['content'],
                            "minutes": document.data()['minutes'],
                            "subject": document.data()['subject'],
                            "link": document.data()['link'],
                          },
                          onTap: (value) {
                            onSelected(value);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 48,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.blue,
        // foregroundColor: Colors.black,
        onPressed: () {
          String _videoUrl = '';
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Sugerir Vídeo'),
              content: TextField(
                onChanged: (value) {
                  _videoUrl = value;
                },
                decoration: InputDecoration(hintText: "Link do vídeo"),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_videoUrl.isNotEmpty) {
                      await databaseProvider.addVideoSuggestion(_videoUrl);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Enviar'),
                ),
              ],
            ),
          );
        },
        icon: Icon(
          Icons.lightbulb,
          color: Colors.white,
        ),
        label: Text(
          'Sugerir Vídeo',
          style: AppTextStyles.label,
        ),
      ),
    );
  }
}
