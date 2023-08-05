import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screens/home.dart';

class AuthService{

  Future signIn(String email, String password, BuildContext context) async {

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } catch(e){
      if (kDebugMode) {
          print(e);
      }
    }

    if(context.mounted){
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
    }

  }
}