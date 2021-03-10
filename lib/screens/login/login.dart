import 'package:devpush/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthBloc>(builder: (context, auth, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              await auth.loginAction();
            },
            child: const Text('Login'),
          ),
          Text(auth.errorMessage ?? ''),
        ],
      );
    });
  }
}
