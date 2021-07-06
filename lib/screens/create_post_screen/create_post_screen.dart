import 'package:devpush/components/simple_button.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:flutter/gestures.dart';
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
  bool tapped = false;

  void createPost() {
    postId = randomAlphaNumeric(16);
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> postData = {
        "userId": Provider.of<DatabaseProvider>(context, listen: false).user.id,
        "postUserName":
            Provider.of<DatabaseProvider>(context, listen: false).user.login,
        "postProfilePicture":
            Provider.of<DatabaseProvider>(context, listen: false)
                .user
                .avatarUrl,
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
      resizeToAvoidBottomInset: true,
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
                  decoration: InputDecoration(
                    hintText: 'Conteúdo',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    postContent = val;
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                !tapped
                    ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Toque aqui para ler as regras',
                          style: AppTextStyles.description12,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                tapped = true;
                              });
                            },
                        ),
                      )
                    : RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text:
                              'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate',
                          style: AppTextStyles.description12,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                tapped = false;
                              });
                            },
                        ),
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
