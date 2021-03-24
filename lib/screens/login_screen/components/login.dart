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
    String errorMessage = authProvider.errorMessage;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            await authProvider.loginAction();
          },
          child: const Text('Login'),
        ),
        Text(errorMessage ?? ''),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Ao utilizar este serviço, você concorda com nossos\n",
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: "Termos de Uso",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
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
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
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
    );
  }
}
