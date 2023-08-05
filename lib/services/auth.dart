import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ipic/screens/home.dart';
import 'package:ipic/services/data.dart';

import '../authentication/signIn.dart';

class AuthService{

  DataService dataService= DataService();
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
          MaterialPageRoute(builder: (context) => const Home()),
              (route) => false);
    }
  }

  Future signUp(String email, String password,String name, String branch, String year, String admission_no, BuildContext context) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    } catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    if(context.mounted){
      dataService.DataInsertUsers(name, email, branch, year, admission_no, context);
      // dataService.DataInsertYearBranch(name, email, branch, year, admission_no, context);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
              (route) => false);
    }
  }

}
