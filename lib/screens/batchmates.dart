import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/StudentsModel.dart';

class Batchmates extends StatefulWidget {
  final String branch;
  final String year;
  Batchmates({required this.branch,required this.year});

  @override
  State<Batchmates> createState() => _BatchmatesState();
}

class _BatchmatesState extends State<Batchmates> {

  int flag=0;
  List<StudentsModel>? list=[];
  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/find';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"users",
      "filter":{
        "branch": widget.branch,
        "year": widget.year
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
          list?.add(StudentsModel(name: data['documents'][i]['name'], count: (i+1).toString(),));
        });
      }
      flag=1;
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if(flag==1){
      return Scaffold(
        appBar: AppBar(
          title: Text('Batchmates'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: list!.map((classes){
              return Card(
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(classes.count+'.',style: TextStyle(fontSize: 20)),
                          SizedBox(width: 5,),
                          Text(classes.name,style: TextStyle(fontSize: 20),),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }else{
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
