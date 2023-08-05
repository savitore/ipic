import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ipic/Utils/Keys.dart';

import '../models/StudentsModel.dart';

class Batchmates extends StatefulWidget {
  final String branch;
  final String year;
  const Batchmates({super.key, required this.branch,required this.year});

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
    final http.Response response;
    try{
      response=await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type':'application/json',
            'Accept':'application/json',
            'Access-Control-Request-Headers':'Access-Control-Allow-Origin, Accept',
            'api-key':Keys().apiKey},
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
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
      return flag==1 ?
      Scaffold(
        appBar: AppBar(
          title: const Text('Batchmates'),
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
                          Text('${classes.count}.',style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 5,),
                          Text(classes.name,style: const TextStyle(fontSize: 20),),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ) :
      const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
  }
}
