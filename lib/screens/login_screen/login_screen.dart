import 'package:devpush/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devpush/providers/auth_provider.dart';
import 'package:devpush/screens/login_screen/components/login.dart';
import 'package:devpush/screens/login_screen/components/success_login.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    bool isBusy = authProvider.isBusy;
    bool isLoggedIn = authProvider.isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: isBusy
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightGray),
              )
            : isLoggedIn
                ? SuccessLogin()
                : Login(),
      ),
    );
  }
}
