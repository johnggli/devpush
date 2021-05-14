import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final String postDateTime;
  const PostCard({
    Key key,
    @required this.postDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

    final difference = DateTime.parse(postDateTime);
    return Container(
      child: Text(timeago.format(difference, locale: 'pt_BR')),
    );
  }
}
