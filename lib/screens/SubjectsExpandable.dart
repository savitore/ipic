import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;

import '../models/MaterialsModel.dart';

class SubjectsExpandable extends StatefulWidget {
  final String subject;
  final String branch;
  final String year;
  final String prof;
  SubjectsExpandable({required this.subject, required this.branch, required this.year, required this.prof});

  @override
  State<SubjectsExpandable> createState() => _SubjectsExpandableState();
}

class _SubjectsExpandableState extends State<SubjectsExpandable> {

  List<MaterialsModel>? materials=[];
  int flag=0;
  double? _progress;
  @override
  void initState() {
    super.initState();
    fetchMaterials();
  }

  Future<void> fetchMaterials() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/find';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"materials",
      "filter":{
        "subject": widget.subject,
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
          materials?.add(MaterialsModel(notice: data['documents'][i]['notice'], attachment: data['documents'][i]['attachment'], nameFile: data['documents'][i]['nameFile']));
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
          centerTitle: true,
          title: Text(widget.subject),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Your attendance: ',style: TextStyle(fontSize: 18),),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: materials!.map((materials){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('assets/empty_person.jpg'),
                                  // backgroundImage: NetworkImage('url'),
                                  radius: 18,
                                ),
                                SizedBox(width: 15),
                                Text(widget.prof,style: TextStyle(fontSize: 23),),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Text(materials.notice+'.',style: TextStyle(fontSize: 20)),
                            SizedBox(height: 15,),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.all(Radius.circular(50))
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
                                        print('path $value');
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
              ),
            ],
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
