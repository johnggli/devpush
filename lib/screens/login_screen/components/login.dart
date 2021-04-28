import 'package:devpush/core/app_gradients.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/core/app_images.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devpush/providers/auth_provider.dart';
// import 'package:url_launcher/url_launcher.dart';

class Login extends StatelessWidget {
  // void _launchURL(String url) async =>
  //     await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
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
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 128,
            child: Image.asset(
              AppImages.logo,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 28, left: 28, right: 28, bottom: 42),
            child: Container(
              width: 310,
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
                  SizedBox(
                    height: 48,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await authProvider.loginAction();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: 310,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppGradients.linearBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              AppImages.githubLogo,
                            ),
                          ),
                          Text(
                            'Entrar com o Github',
                            style: AppTextStyles.label,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.input,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
