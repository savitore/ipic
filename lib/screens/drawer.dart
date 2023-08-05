import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authentication/SignIn.dart';

class MyDrawer extends StatefulWidget {
  final String name,email;
  const MyDrawer(this.name,this.email, {super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100,left: 20,right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text(widget.name,style: TextStyle(fontSize: MediaQuery.of(context).size.width/18),),
                ],
              ),
              Row(
                children: [
                  Text(widget.email,style: TextStyle(fontSize: MediaQuery.of(context).size.width/30,color: Colors.grey[600]),),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Divider(height: 1,thickness: 0.5,color: Colors.grey[500],),
          const SizedBox(height: 550,),
          Divider(height: 1,thickness: 0.5,color: Colors.grey[500],),
          const SizedBox(height: 10,),
          Row(
            children: [
              GestureDetector(
                child: const Text('Log out'),
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=> const SignIn())
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 50,)
        ],
      ),
    );
  }
}
