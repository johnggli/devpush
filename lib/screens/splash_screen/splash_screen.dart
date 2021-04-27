// import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_gradients.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
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
          gradient: AppGradients.linear,
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
}
