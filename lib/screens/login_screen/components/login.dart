import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_gradients.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/core/app_images.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devpush/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatelessWidget {
  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

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
        // top: MediaQuery.of(context).size.height * 0.24,
        top: MediaQuery.of(context).size.height * 0.2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // width: 128,
            width: MediaQuery.of(context).size.height * 0.2,
            child: Image.asset(
              AppImages.logo,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              width: 310,
              child: Column(
                children: [
                  Text(
                    'Bem-vindo ao DevPush!',
                    style: AppTextStyles.title,
                  ),
                  SizedBox(
                    // height: 24,
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    'Compartilhe conquistas, divirta-se e aprenda a ser um programador melhor, todos os dias!',
                    style: AppTextStyles.description14,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    // height: 48,
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Container(
                    width: 310,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppGradients.linearBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          await authProvider.loginAction();
                        },
                        splashColor: AppColors.blue,
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  Icons.login,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Ao entrar, você concorda com nossos\n",
                        style: AppTextStyles.description12,
                        children: [
                          TextSpan(
                            text: "Termos de Uso",
                            style: TextStyle(
                              color: AppColors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchURL(
                                    'https://sites.google.com/view/devpush/termos-de-uso');
                              },
                          ),
                          TextSpan(text: " e "),
                          TextSpan(
                            text: "Política de Privacidade",
                            style: TextStyle(
                              color: AppColors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchURL(
                                    'https://sites.google.com/view/devpush/politica-de-privacidade');
                              },
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
  }
}
