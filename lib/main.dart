import 'package:devpush/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';

import 'package:devpush/screens/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        child: SplashScreen(title: 'Flutter Demo Home Page'),
        create: (_) {
          return AuthBloc();
        },
      ),
    );
  }
}
