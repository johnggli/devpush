import 'package:devpush/providers/auth_provider.dart';
import 'package:devpush/providers/github_provider.dart';
import 'package:flutter/material.dart';
import 'package:devpush/screens/main_screen/main_screen.dart';
import 'package:provider/provider.dart';

class SuccessLogin extends StatefulWidget {
  @override
  _SuccessLoginState createState() => _SuccessLoginState();
}

class _SuccessLoginState extends State<SuccessLogin> {
  Future<void> setup() async {
    int userId = Provider.of<AuthProvider>(context, listen: false).userId;
    await Provider.of<GithubProvider>(context, listen: false).setUser(userId);
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
    return CircularProgressIndicator();
  }
}
