import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Utils/Keys.dart';
import 'ClassesExpandable.dart';
import '../models/ClassesModel.dart';
import 'drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int flag=0;
  String name='';
  String? email;
  List<ClassesModel>? list=[];

  @override
  void initState() {
    super.initState();
    email=FirebaseAuth.instance.currentUser?.email;
    fetchClasses();
    fetchDataProfile();
  }

  Future<void> fetchDataProfile() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/findOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"profs",
      "filter":{
        "email": email
      }
    };
    final http.Response response;
    try{
      response=await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type':'application/json',
            'Accept':'application/json',
            'Access-Control-Request-Headers':'Access-Control-Allow-Origin, Accept',
            'api-key': Keys().apiKey},
          body: jsonEncode(body)
      );
      var data = jsonDecode(response.body);
      setState((){
        name=data['document']['name'];
      });
      flag=1;
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> fetchClasses() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/find';
    final body={
      "dataSource":"Cluster0",
      "database":"profs",
      "collection":email,
    };
    final http.Response response;
    try{
      response=await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type':'application/json',
            'Accept':'application/json',
            'Access-Control-Request-Headers':'Access-Control-Allow-Origin, Accept',
            'api-key': Keys().apiKey},
          body: jsonEncode(body)
      );
      var data = jsonDecode(response.body);
      for(int i=0; i<data['documents'].length;i++){
        setState((){
          list?.add(ClassesModel(subject: data['documents'][i]['subject'], branch: data['documents'][i]['branch'], year: data['documents'][i]['year']));
        });
      }
      flag=1;
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(flag==1){
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[500],
            centerTitle: true,
            title: const Text('IIT DHANBAD'),
          ),
          drawer: Drawer(
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MyDrawer(name, email!)
                ],
              ),
            ),
          ),
        body: RefreshIndicator(
          onRefresh: (){
            return Future.delayed(
              const Duration(seconds: 2),
                (){
                fetchClasses();
                }
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('My Classes',style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.w500),),
                  const SizedBox(height: 10,),
                  Column(
                    children: list!.map((classes){
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ClassesExpandable(subject: classes.subject, branch: classes.branch, year: classes.year, name: name,)));
                          },
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(classes.subject,style: const TextStyle(fontSize: 28,fontWeight: FontWeight.w500),),
                                    Text(classes.branch,style: TextStyle(color: Colors.grey[800]),),
                                    Text(classes.year,style: TextStyle(color: Colors.grey[800]))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }else{
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }

}
