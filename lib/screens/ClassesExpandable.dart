import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ipic_profs/Keys.dart';
import 'package:ipic_profs/screens/Post.dart';

import '../models/MaterialsModel.dart';
import '../models/StudentsModel.dart';

class ClassesExpandable extends StatefulWidget {
  final String subject;
  final String branch;
  final String year;
  final String name;
  const ClassesExpandable({super.key, required this.subject,required this.branch,required this.year, required this.name});

  @override
  State<ClassesExpandable> createState() => _ClassesExpandableState();
}

class _ClassesExpandableState extends State<ClassesExpandable> {

  int flag=0;
  String noOfStudents='';
  List<StudentsModel>? list=[];
  List<MaterialsModel>? materials=[];
  double? _progress;
  @override
  void initState() {
    super.initState();
    fetchStudents();
    fetchMaterials();
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
          noOfStudents=data['documents'].length.toString();
        });
      }
      flag=1;
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
  Future<void> fetchMaterials() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/find';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"materials",
      "filter":{
        "subject":widget.subject,
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
          materials?.add(MaterialsModel(notice: data['documents'][i]['notice'].toString(), attachment: data['documents'][i]['attachment'].toString(), nameFile: data['documents'][i]['nameFile'].toString()));
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
          centerTitle: true,
          title: Text(widget.subject),
          actions: [
            InkWell(
                child: const Icon(Icons.info_outline),
              onTap: (){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      scrollable: true,
                      actionsAlignment: MainAxisAlignment.center,
                      title: const Text('Students',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                      content: Padding(
                        padding: const EdgeInsets.all(10.0),
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
                        )
                      ),
                    );
                  });
              },
            ),
            const SizedBox(width: 10,)
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.branch} (${widget.year})',style: const TextStyle(fontSize: 20),),
                      Text('$noOfStudents students',style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=> Post(subject: widget.subject, branch: widget.branch, year: widget.year,))
                  );
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage('assets/empty_person.jpg'),
                            radius: 20,
                          ),
                          const SizedBox(width: 15,),
                          Text('Announce something to your class...',style: TextStyle(color: Colors.grey[600],fontSize: MediaQuery.of(context).size.width/25),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: materials!.map((materials){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('assets/empty_person.jpg'),
                                  // backgroundImage: NetworkImage('url'),
                                  radius: 18,
                                ),
                                SizedBox(width: 15),
                                Text('You',style: TextStyle(fontSize: 23),),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Text('${materials.notice}.',style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 15,),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                borderRadius: const BorderRadius.all(Radius.circular(50))
                              ),
                              child: InkWell(
                                onTap: (){
                                  FileDownloader.downloadFile(
                                      url: materials.attachment,
                                      onProgress: (name,progress){
                                        setState(() {
                                          _progress=progress;
                                        });
                                      },
                                    onDownloadCompleted: (value){
                                        if (kDebugMode) {
                                          print('path $value');
                                        }
                                        setState(() {
                                          _progress=null;
                                        });
                                    }
                                  );
                                },
                                child: Text(materials.nameFile,style: TextStyle(color: Colors.grey[600]),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ) :
       const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
  }
}
