import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devpush/providers/auth_provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    String errorMessage = authProvider.errorMessage;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            await authProvider.loginAction();
          },
          child: const Text('Login'),
        ),
        Text(errorMessage ?? ''),
      ],
    );
  }
}
