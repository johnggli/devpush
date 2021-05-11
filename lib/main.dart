import 'package:devpush/core/app_colors.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/providers/github_provider.dart';
import 'package:devpush/screens/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:devpush/providers/auth_provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: FutureBuilder(
          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        Text('Error!'),
                        Text(snapshot.error.toString())
                      ],
                    ),
                  ),
                ),
              );
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: Colors.white,
                  accentColor: Colors.white,
                ),
                title: 'DevPush',
                home: SplashScreen(),
              );
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                  ),
                ),
              ),
            );
          }),
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => GithubProvider()),
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
      ],
    );
  }
}
