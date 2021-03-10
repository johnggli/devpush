import 'package:devpush/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthBloc>(builder: (context, auth, child) {
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
                image: NetworkImage(auth.picture ?? ''),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Name: ${auth.name}'),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () async {
              await auth.logoutAction();
            },
            child: const Text('Logout'),
          ),
        ],
      );
    });
  }
}
