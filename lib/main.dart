import 'package:Skype_clone/provider/image_upload_provider.dart';
import 'package:Skype_clone/provider/user_provider.dart';
import 'package:Skype_clone/resources/auth_methods.dart';
import 'package:Skype_clone/resources/firebase_repository.dart';
import 'package:Skype_clone/screens/home_screen.dart';
import 'package:Skype_clone/screens/login_screen.dart';
import 'package:Skype_clone/screens/search_screen.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: "ConsulMed",
        title: "Skype Clone",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        theme: ThemeData(brightness: Brightness.light),
        home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
        theme: ThemeData( brightness: Brightness.dark),
        home: FutureBuilder(
          future: _repository.getCurrentUser(),
          builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
