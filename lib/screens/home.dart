import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipic/screens/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:ipic/services/data.dart';

import 'SubjectsExpandable.dart';
import '../models/SubjectsModel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int flag=0;
  String name='',branch='',year='',admission_no='';
  String? email;
  List<SubjectsModel>? subjects=[];
  DataService dataService= DataService();

  @override
  void initState() {
    super.initState();
    email=FirebaseAuth.instance.currentUser?.email;
    fetchDataProfile();
  }
  Future<void> fetchDataProfile() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/findOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"users",
      "filter":{
        "email": email
      }
    };
    final response;
    try{
      response=await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type':'application/json',
            'Accept':'application/json',
            'Access-Control-Request-Headers':'Access-Control-Allow-Origin, Accept',
            'api-key':'81FEjMN5H02pecyUbWBRC7PgCS2Mz4fmOo6LR7IOd2dp1SQ4DLHf6gCcn238huTf'},
          body: jsonEncode(body)
      );
      var data = jsonDecode(response.body);
      setState((){
        admission_no=data['document']['admission_no'];
        name=data['document']['name'];
        branch=data['document']['branch'];
        year=data['document']['year'];
      });
      fetchSubjects();
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> fetchSubjects() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/find';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"subjects",
      "filter":{
        "branch": branch,
        "year": year
      }
    };
    final response;
    try{
      response=await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type':'application/json',
            'Accept':'application/json',
            'Access-Control-Request-Headers':'Access-Control-Allow-Origin, Accept',
            'api-key':'81FEjMN5H02pecyUbWBRC7PgCS2Mz4fmOo6LR7IOd2dp1SQ4DLHf6gCcn238huTf'},
          body: jsonEncode(body)
      );
      var data = jsonDecode(response.body);
      for(int i=0; i<data['documents'].length;i++){
        setState((){
          subjects?.add(SubjectsModel(subject: data['documents'][i]['subject'], prof: data['documents'][i]['prof']));
        });
      }
      flag=1;
      getHttprequest();
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> getHttprequest() async {
    String url ="https://script.google.com/macros/s/AKfycbzo3Y7RbXL5AeFFiB-v0zu19DGyzCkckcf2PAHs6jdl7-XXuhslffiU6qWsRtBCPNQe/exec";
    try{
      final response = await http.get(Uri.parse(url),headers: {'Content-Type':'application/json'});
      var data= jsonDecode(response.body);
      setState(() {
        for(var i=0; i<data["data"].length;i++){
          print("hi"+data["data"].length.toString());
          if(admission_no==data["data"][i]['Admission_ID']){
            dataService.DataInsertAttendance(data["data"][i]['Admission_ID'], data["data"][i]['Date'], data["data"][i]['Time']);
          }

        }
      });
    } catch(e){
      print("catch/" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if(flag==1){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[500],
          centerTitle: true,
          title: Text('Classroom'),
        ),
        drawer: Drawer(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MyDrawer(admission_no, year, branch, name, email!)
                ],
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: subjects!.map((subjects){
            return InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubjectsExpandable(subject: subjects.subject, branch: branch, year: year, prof: subjects.prof,)));
              },
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(subjects.subject,style: TextStyle(fontSize: 28,fontWeight: FontWeight.w500),),
                        SizedBox(height: 5,),
                        Text(subjects.prof,style: TextStyle(color: Colors.grey[800],fontSize: 20),),
                        SizedBox(height: 5 ,)
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }else{
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }

}
