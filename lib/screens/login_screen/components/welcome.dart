import 'package:devpush/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devpush/providers/auth_provider.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    // String picture = authProvider.picture;
    String name = authProvider.name;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Bem vindo $name!'),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          },
          child: const Text('Continuar'),
        ),
      ],
    );
  }
}
