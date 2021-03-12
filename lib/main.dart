import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devpush/routes.dart';
import 'package:devpush/screens/login_screen/login_screen.dart';
import 'package:devpush/providers/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: SplashScreen(title: 'Flutter Demo Home Page'),
        initialRoute: LoginScreen.routeName,
        routes: routes,
      ),
      create: (context) {
        return AuthProvider();
      },
    );
  }
}
