import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String name,email,branch,year,admission_no;
  const Profile(this.admission_no,this.year,this.branch,this.name,this.email, {super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[500],
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 8, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name',style: TextStyle(color: Colors.grey[700],fontSize: 20),),
            const SizedBox(height: 5,),
            Text(widget.name,
                style: const TextStyle(color: Colors.black,fontSize: 20)),
            const SizedBox(height: 10,),
            Text('Email',style: TextStyle(color: Colors.grey[700],fontSize: 20),),
            const SizedBox(height: 5,),
            Text(widget.email,style: const TextStyle(color: Colors.black,fontSize: 20)),
            const SizedBox(height: 10,),
            Text('Admission Number',style: TextStyle(color: Colors.grey[700],fontSize: 20),),
            const SizedBox(height: 5,),
            Text(widget.admission_no,style: const TextStyle(color: Colors.black,fontSize: 20)),
            const SizedBox(height: 10,),
            Text('Year of Study',style: TextStyle(color: Colors.grey[700],fontSize: 20),),
            const SizedBox(height: 5,),
            Text(widget.year,style: const TextStyle(color: Colors.black,fontSize: 20)),
            const SizedBox(height: 10,),
            Text('Branch',style: TextStyle(color: Colors.grey[700],fontSize: 20),),
            const SizedBox(height: 5,),
            Text(widget.branch,style: const TextStyle(color: Colors.black,fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
