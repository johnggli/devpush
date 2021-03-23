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
              text: "By creating an account, you are agreeing to our\n",
              style: Theme.of(context).textTheme.bodyText1,
              children: [
                TextSpan(
                  text: "Terms & Conditions ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchURL(
                          'https://sites.google.com/view/meteorrainapp/privacy-policy-kaomoji');
                    },
                ),
                TextSpan(text: "and "),
                TextSpan(
                  text: "Privacy Policy! ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchURL('https://github.com/JohnEmerson1406');
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
