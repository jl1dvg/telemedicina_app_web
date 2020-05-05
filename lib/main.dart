import 'package:Skype_clone/provider/image_upload_provider.dart';
import 'package:Skype_clone/provider/user_provider.dart';
<<<<<<< HEAD
import 'package:Skype_clone/resources/auth_methods.dart';
=======
import 'package:Skype_clone/resources/firebase_repository.dart';
>>>>>>> 8d3b72fdf2b716d41b68ec03e4bb3e102d0f49cb
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
<<<<<<< HEAD
=======

>>>>>>> 8d3b72fdf2b716d41b68ec03e4bb3e102d0f49cb
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
<<<<<<< HEAD
        title: "ConsulMed",
=======
        title: "Skype Clone",
>>>>>>> 8d3b72fdf2b716d41b68ec03e4bb3e102d0f49cb
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
<<<<<<< HEAD
        theme: ThemeData(brightness: Brightness.light),
        home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
=======
        theme: ThemeData( brightness: Brightness.dark),
        home: FutureBuilder(
          future: _repository.getCurrentUser(),
>>>>>>> 8d3b72fdf2b716d41b68ec03e4bb3e102d0f49cb
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
