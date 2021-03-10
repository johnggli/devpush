import 'package:devpush/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';

import 'package:devpush/screens/home/home.dart';
import 'package:devpush/screens/login/login.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthBloc>(builder: (context, auth, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Splash Screen'),
        ),
        body: Center(
          child: auth.isBusy
              ? const CircularProgressIndicator()
              : auth.isLoggedIn
                  ? Home()
                  : Login(),
        ),
      );
    });
  }

  @override
  void initState() {
    Provider.of<AuthBloc>(context, listen: false).initAction();
    super.initState();
  }
}
