import 'package:flutter/material.dart';

import '../services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var email="",password="";
  var formKey = GlobalKey<FormState>();
  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 100, 40, 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text('SIGN IN',style: TextStyle(color: Colors.white,fontSize: 25),),
                const SizedBox(height: 30,),
                TextFormField(
                  validator: (val)=> val!.isEmpty? 'Enter Your Email':null,
                  keyboardType: TextInputType.text,
                  onChanged: (value){
                    email=value;
                  },
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      filled: true,
                      fillColor: Colors.blue[300],
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      hintText: "Enter Your Email"
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  validator: (val)=> val!.isEmpty? 'Enter Your Password':null,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  onChanged: (value){
                    password=value;
                  },
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      filled: true,
                      fillColor: Colors.blue[300],
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      hintText: "Enter Your Password"
                  ),
                ),
                const SizedBox(height: 40,),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if(formKey.currentState!.validate()){
                        showLoaderDialog(BuildContext context){
                          AlertDialog alert = AlertDialog(
                            content: Row(
                              children: [
                                const CircularProgressIndicator(),
                                Container(margin: const EdgeInsets.only(left: 7),child: const Text("Loading..."),)
                              ],
                            ),
                          );
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context){
                                return alert;
                              }
                          );
                        }
                        showLoaderDialog(context);
                        authService.signIn(email, password,context);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    child: const Text('LOGIN',style: TextStyle(color: Colors.blue,fontSize: 17),),
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
