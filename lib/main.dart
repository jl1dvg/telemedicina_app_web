import 'package:firebase/firebase.dart' as WebFirebase;
import 'package:flutter/material.dart';
import 'package:telemedicina/screens/home_screen.dart';
import 'package:telemedicina/screens/login_screen.dart';
import 'package:telemedicina/screens/search_screen.dart';
import 'package:telemedicina/services/auth_methods.dart';

void main() {
  WebFirebase.initializeApp(
      apiKey: "AIzaSyB3XaTquUje8JAFGVVR3nTRemEsMHHLdAY",
      authDomain: "skype-426f7.firebaseapp.com",
      databaseURL: "https://skype-426f7.firebaseio.com",
      projectId: "skype-426f7",
      storageBucket: "skype-426f7.appspot.com",
      messagingSenderId: "328407005780",
      appId: "1:328407005780:web:ffb997600969c8d71d4bc1");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Skype Clone",
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/search_screen': (context) => SearchScreen(),
      },
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      home: FutureBuilder(
        future: _authMethods.getCurrentUser(),
        builder: (context, AsyncSnapshot<WebFirebase.User> snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
