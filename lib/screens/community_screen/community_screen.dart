import 'package:devpush/core/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    String datetime = '2021-05-14 14:04:14.558802';

    final difference = DateTime.parse(datetime);

    print('========================================== $difference');

    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

    print(timeago.format(difference, locale: 'pt_BR'));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Comunidade',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        children: [
          Container(),
        ],
      ),
    );
  }
}
