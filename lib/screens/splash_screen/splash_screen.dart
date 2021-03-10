import 'package:flutter/material.dart';
import 'package:devpush/screens/login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var duration = Duration(seconds: 3);

    Future.delayed(duration, () {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hello Splash Screen'),
          ],
        ),
      ),
    );
  }
}
