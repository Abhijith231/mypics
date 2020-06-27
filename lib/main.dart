import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypics/providers/photoprovider.dart';

import 'package:provider/provider.dart';

import './screens/MainScreen.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: PhotoProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'MyPics',
        theme: ThemeData(
          primarySwatch: colorCustom,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LandingPage(),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }
          return MainScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class SignInPage extends StatelessWidget {
  Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0x96577F),
        child: Center(
          child: RaisedButton(
            child: Text('Let\'s Start'),
            onPressed: _signInAnonymously,
            color: Color(0x1F3095),
          ),
        ),
      ),
    );
  }
}

// #1F3095
// #96577F
// #FA8E44
