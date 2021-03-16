import 'package:flutter/widgets.dart';
import 'package:devpush/screens/login_screen/login_screen.dart';
import 'package:devpush/screens/main_screen/main_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  MainScreen.routeName: (context) => MainScreen(),
};
