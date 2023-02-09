import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'authentication/signIn.dart';
import 'screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  Widget first;
  if (firebaseUser != null) {
    first = Home();
  } else {
    first = SignIn();
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: first,
  ));
}
