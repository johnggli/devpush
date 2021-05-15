import 'package:devpush/components/simple_button.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/providers/github_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({
    Key key,
  }) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();

  String postId;
  String postContent = '';

  void createPost() {
    postId = randomAlphaNumeric(16);
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> postData = {
        "userId": Provider.of<GithubProvider>(context, listen: false).user.id,
        "postUserName":
            Provider.of<GithubProvider>(context, listen: false).user.login,
        "postProfilePicture":
            Provider.of<GithubProvider>(context, listen: false).user.avatarUrl,
        "postContent": postContent,
        "postDateTime": "${DateTime.now()}",
        "postPoints": 0,
      };

      Provider.of<DatabaseProvider>(context, listen: false)
          .addPost(postData, postId);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.lightGray,
        ),
        centerTitle: true,
        title: Text(
          'Nova Postagem',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: ListView(
              children: [
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (val) =>
                      val.isEmpty ? 'Conteúdo não pode ficar em branco' : null,
                  decoration: InputDecoration(hintText: 'Conteúdo'),
                  onChanged: (val) {
                    postContent = val;
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                SimpleButton(
                  color: AppColors.blue,
                  title: 'Enviar',
                  onTap: createPost,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}