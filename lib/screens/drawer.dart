import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipic/screens/batchmates.dart';
import 'package:ipic/screens/profile.dart';

import '../authentication/signIn.dart';

class MyDrawer extends StatefulWidget {
  late final String name,email,branch,year,admission_no;
  MyDrawer(this.admission_no,this.year,this.branch,this.name,this.email);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70,left: 20,right: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> Profile(widget.admission_no, widget.year, widget.branch, widget.name, widget.email)
                ));
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(widget.name,style: TextStyle(fontSize: 30),),
                    ],
                  ),
                  Row(
                    children: [
                      Text(widget.admission_no,style: TextStyle(fontSize: 15,color: Colors.grey[600]),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Text('View Profile')
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Divider(height: 1,thickness: 0.5,color: Colors.grey[500],),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=> Batchmates(branch: widget.branch, year: widget.year,)
                ));
              },
              child: Row(
                children: [
                  Icon(Icons.person_outline,size: 22,),
                  SizedBox(width: 5,),
                  Text('Batchmates',style: TextStyle(fontSize: 19),)
                ],
              ),
            ),
            SizedBox(height: 400,),
            Divider(height: 1,thickness: 0.5,color: Colors.grey[500],),
            SizedBox(height: 10,),
            Row(
              children: [
                GestureDetector(
                    child: Text('Log out'),
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=> SignIn())
                  );
                },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
