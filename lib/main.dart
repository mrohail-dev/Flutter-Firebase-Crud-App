// @dart=2.9
import 'package:crud_app/login.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/register.dart';
import 'package:crud_app/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              title: 'flutter demo',
              theme: ThemeData(
                primarySwatch: Colors.blueGrey,
              ),
              home: Login(),
            routes: {
                "/login": (context) => Login(),
              "/register": (context)=> Register(),
              "/home": (context)=> Home(),
            }
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
  }
}