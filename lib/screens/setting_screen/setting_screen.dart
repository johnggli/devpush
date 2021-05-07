import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/auth_provider.dart';
import 'package:devpush/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.lightGray,
        ),
        centerTitle: true,
        title: Text(
          'Definições',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        physics: ClampingScrollPhysics(),
        children: [
          GestureDetector(
            onTap: () {
              _launchURL('https://sites.google.com/view/devpush/termos-de-uso');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.grading,
                    color: AppColors.dark,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Termos de uso',
                    style: AppTextStyles.subHead,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _launchURL(
                  'https://sites.google.com/view/devpush/politica-de-privacidade');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip,
                    color: AppColors.dark,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Política de privacidade',
                    style: AppTextStyles.subHead,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 18,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Tem Certeza?'),
                  content: Text('Deseja sair da sua conta atual?'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await authProvider.logoutAction();
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    LoginScreen(),
                          ),
                        );
                      },
                      child: Text('Sim'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: 310,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'SAIR',
                  style: AppTextStyles.label,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Center(
            child: Text(
              'Versão 1.0',
              style: AppTextStyles.description14,
            ),
          ),
          Center(
            child: Text(
              '@2021 DevPush',
              style: AppTextStyles.description14,
            ),
          ),
        ],
      ),
    );
  }
}
