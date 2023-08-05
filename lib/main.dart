import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'authentication/SignIn.dart';
import 'screens/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  Widget first;
  if (firebaseUser != null) {
    first = const Home();
  } else {
    first = const SignIn();
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: first,
  ));
}
