import 'package:expense_app/Screens/homePage.dart';
import 'package:expense_app/Screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  bool isLoggedIn = false;
  @override
  void initState() {
    user = auth.currentUser;
    if(user != null)
      {
        setState(() {
          isLoggedIn = true;
        });
      }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        nextScreen: isLoggedIn ? HomePage() : LoginScreen(),
        splash: Image.asset("assets/image/animation.gif"),
        splashIconSize: 150,
      ),
    );
  }
}
