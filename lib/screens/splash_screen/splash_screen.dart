import 'package:devpush/core/app_gradients.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/providers/auth_provider.dart';
import 'package:devpush/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2)).then(
      (value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      ),
    );

    return Scaffold(
      body: Container(
        // color: AppColors.black,
        decoration: BoxDecoration(
          gradient: AppGradients.linearPurple,
        ),
        child: Center(
          child: Container(
            width: 178,
            child: Image.asset(
              AppImages.introLogo,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).initAction();
    super.initState();
  }
}
