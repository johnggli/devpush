import 'package:devpush/core/app_colors.dart';
import 'package:devpush/providers/auth_provider.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:devpush/screens/main_screen/main_screen.dart';
import 'package:provider/provider.dart';

class SuccessLogin extends StatefulWidget {
  @override
  _SuccessLoginState createState() => _SuccessLoginState();
}

class _SuccessLoginState extends State<SuccessLogin> {
  Future<void> setup() async {
    // get logged user id
    int userId = Provider.of<AuthProvider>(context, listen: false).userId;

    // set user data
    await Provider.of<DatabaseProvider>(context, listen: false)
        .initUser(userId);
  }

  @override
  void initState() {
    super.initState();
    setup().then((_) {
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
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightGray),
    );
  }
}
