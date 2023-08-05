import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;

import '../Utils/Keys.dart';
import '../models/MaterialsModel.dart';

class SubjectsExpandable extends StatefulWidget {
  final String subject;
  final String branch;
  final String year;
  final String prof;
  final String admission_no;
  const SubjectsExpandable({super.key, required this.subject, required this.branch, required this.year, required this.prof, required this.admission_no});

  @override
  State<SubjectsExpandable> createState() => _SubjectsExpandableState();
}

class _SubjectsExpandableState extends State<SubjectsExpandable> {

  List<MaterialsModel>? materials=[];
  int flag=0;
  double? _progress;
  late String date;
  late String attendance;
  @override
  void initState() {
    super.initState();
    fetchMaterials();
    getHttprequest();
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
          materials?.add(MaterialsModel(notice: data['documents'][i]['notice'], attachment: data['documents'][i]['attachment'], nameFile: data['documents'][i]['nameFile']));
        });
      }
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
  Future<void> getHttprequest() async {
    String url ="https://script.google.com/macros/s/AKfycbzo3Y7RbXL5AeFFiB-v0zu19DGyzCkckcf2PAHs6jdl7-XXuhslffiU6qWsRtBCPNQe/exec";
    try{
      final response = await http.get(Uri.parse(url),headers: {'Content-Type':'application/json'});
      var data= jsonDecode(response.body);
      setState(() {
        for(var i=0; i<data["data"].length;i++){
          if (kDebugMode) {
            print("hi${data["data"].length}");
          }
          if(widget.admission_no==data["data"][i]['Admission_ID']){
            date=data["data"][i]['Date'].toString().substring(0,10);
            attendance="Present";
            return;
          }else{
            date=data["data"][1]['Date'].toString().substring(0,10);
            attendance="Absent";
          }
          flag=1;
        }
      });
    } catch(e){
      if (kDebugMode) {
        print("catch/$e");
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
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('Your attendance: ',style: TextStyle(fontSize: 18),),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Text('$date:',style: const TextStyle(fontSize: 18),),
                          const SizedBox(width: 5,),
                          Text(attendance,style: const TextStyle(fontSize: 18),)
                        ],
                      ),
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
                                const CircleAvatar(
                                  backgroundImage: AssetImage('assets/empty_person.jpg'),
                                  // backgroundImage: NetworkImage('url'),
                                  radius: 18,
                                ),
                                const SizedBox(width: 15),
                                Text(widget.prof,style: const TextStyle(fontSize: 23),),
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
              ),
            ],
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
