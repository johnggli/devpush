import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devpush/providers/auth_provider.dart';
import 'package:devpush/screens/home/home.dart';
import 'package:devpush/screens/login/login.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    bool isBusy = authProvider.isBusy;
    bool isLoggedIn = authProvider.isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash Screen'),
      ),
      body: Center(
        child: isBusy
            ? const CircularProgressIndicator()
            : isLoggedIn
                ? Home()
                : Login(),
      ),
    );
  }

  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).initAction();
    super.initState();
  }
}
