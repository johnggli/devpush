import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devpush/providers/auth_provider.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    String picture = authProvider.picture;
    String name = authProvider.name;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 4),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(picture ?? ''),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Name: $name'),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () async {
            await authProvider.logoutAction();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
