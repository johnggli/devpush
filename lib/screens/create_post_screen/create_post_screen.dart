import 'package:devpush/components/simple_button.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
        "createdAt": "${DateTime.now()}",
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
                SizedBox(
                  height: 6,
                ),
                !tapped
                    ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Toque aqui para ler as regras',
                          style: GoogleFonts.nunito(
                            color: AppColors.lightGray,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
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
                              'Postar qualquer tipo de conteúdo ou link sexualmente explícito irá fazer você ser BANIDO. Além disso, é proibido discurso de ódio ou descriminação, assédio, ameaças ou intimidações a outros membros, SPAM, alegações de autoria sobre conteúdo que não lhe pertence e outros aspectos citados e proibidos nos Termos de Uso. Também, isto não é um fórum (já que não há maneira de responder as mensagens postadas). Limite as suas postagens aqui apenas a curiosidades, notícias ou textos motivacionais.',
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
                  height: 6,
                ),
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
