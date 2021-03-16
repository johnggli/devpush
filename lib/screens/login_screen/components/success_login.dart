import 'package:flutter/material.dart';
import 'package:devpush/screens/main_screen/main_screen.dart';

class SuccessLogin extends StatefulWidget {
  @override
  _SuccessLoginState createState() => _SuccessLoginState();
}

class _SuccessLoginState extends State<SuccessLogin> {
  @override
  void initState() {
    super.initState();

    // The delay fixes it
    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
