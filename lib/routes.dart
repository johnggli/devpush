import 'package:flutter/widgets.dart';
import 'package:devpush/screens/splash_screen/splash_screen.dart';
import 'package:devpush/screens/login_screen/login_screen.dart';
import 'package:devpush/screens/home_screen/home_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
};
