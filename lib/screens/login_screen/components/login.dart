import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/core/app_images.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:devpush/providers/auth_provider.dart';
// import 'package:url_launcher/url_launcher.dart';

class Login extends StatelessWidget {
  // void _launchURL(String url) async =>
  //     await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    // var authProvider = Provider.of<AuthProvider>(context);
    // String errorMessage = authProvider.errorMessage;

    // return Container(
    //   child: Center(
    //     child: Container(
    //       width: 128,
    //       child: Image.asset(
    //         AppImages.logo,
    //       ),
    //     ),
    //   ),
    // );

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(top: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 128,
            child: Image.asset(
              AppImages.logo,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    Text(
                      'Bem-vindo ao DevPush!',
                      style: AppTextStyles.title,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Compartilhe conquistas, divirta-se e aprenda a ser um programador melhor, todos os dias!',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),
          // Column(
          //   children: [
          //     Row(
          //       children: [
          //         Expanded(
          //             child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 68),
          //           child: NextButtonWidget.green(
          //               label: 'Compartilhar',
          //               onTap: () {
          //                 Share.share(
          //                     'DevQuiz NLW 5 - Flutter: Resultado do Quiz: $title\nObtive: ${result / length}% de aproveitamento!');
          //               }),
          //         )),
          //       ],
          //     ),
          //     SizedBox(
          //       height: 24,
          //     ),
          //     Row(
          //       children: [
          //         Expanded(
          //             child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 68),
          //           child: NextButtonWidget.white(
          //               label: 'Voltar ao início',
          //               onTap: () {
          //                 Navigator.pop(context);
          //               }),
          //         )),
          //       ],
          //     ),
          //   ],
          // )
        ],
      ),
    );

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     ElevatedButton(
    //       onPressed: () async {
    //         await authProvider.loginAction();
    //       },
    //       child: const Text('Login'),
    //     ),
    //     Text(errorMessage ?? ''),
    //     SizedBox(height: 24),
    //     Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: RichText(
    //         textAlign: TextAlign.center,
    //         text: TextSpan(
    //           text: "Ao utilizar este serviço, você concorda com nossos\n",
    //           style: DefaultTextStyle.of(context).style,
    //           children: [
    //             TextSpan(
    //               text: "Termos de Uso",
    //               style: TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   decoration: TextDecoration.underline),
    //               recognizer: TapGestureRecognizer()
    //                 ..onTap = () {
    //                   _launchURL(
    //                       'https://sites.google.com/view/devpush/termos-de-uso');
    //                 },
    //             ),
    //             TextSpan(text: " e "),
    //             TextSpan(
    //               text: "Política de Privacidade",
    //               style: TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   decoration: TextDecoration.underline),
    //               recognizer: TapGestureRecognizer()
    //                 ..onTap = () {
    //                   _launchURL(
    //                       'https://sites.google.com/view/devpush/politica-de-privacidade');
    //                 },
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
