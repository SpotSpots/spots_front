import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'InfoScreen.dart';
import 'firebase_options.dart';
import 'LogoPage.dart';
import 'package:spotsfront/fab_with_icons.dart';
import 'package:spotsfront/fab_bottom_app_bar.dart';
import 'package:spotsfront/layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff8EC3EE)),
        //primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return HomePage();
            return InfoScreen();
          }
          else {
            return const LogoPage();
          }
        },
      ),
    );
  }
}

