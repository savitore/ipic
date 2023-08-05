import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';


class Post extends StatefulWidget {
  final String subject;
  final String branch;
  final String year;
  Post({required this.subject,required this.branch,required this.year});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {

  var share="";
  UploadTask? uploadTask;
  late double progress;
  late final urlDownload, nameFile;

  Future MaterialInsert(String subject, String branch, String year, BuildContext context) async {
    String baseUrl='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"materials",
      "document":{
        "subject":subject,
        "branch":branch,
        "year": year,
        "notice":share,
        "attachment": urlDownload,
        "nameFile":nameFile
      }
    };
    HttpClient httpClient=new HttpClient();
    HttpClientRequest httpClientRequest=await httpClient.postUrl(Uri.parse(baseUrl));
    httpClientRequest.headers.set("Content-Type", "application/json");
    httpClientRequest.headers.set("api-key", "81FEjMN5H02pecyUbWBRC7PgCS2Mz4fmOo6LR7IOd2dp1SQ4DLHf6gCcn238huTf");
    httpClientRequest.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse response=await httpClientRequest.close();
    httpClient.close();
    final contents = StringBuffer();
    await for (var data in response.transform(utf8.decoder)) {
      contents.write(data);
    }
    var output=jsonDecode(contents.toString());
    print(output['insertedId']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext){
            return IconButton(
                onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.cancel_outlined)
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: (value) {
                share = value;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.dehaze_rounded,color: Colors.black,),
                hintStyle: TextStyle(color: Colors.grey[700],fontSize: 18),
                  border: InputBorder.none,
                  hintText: "Share with your class"
              ),
            ),
          ),
          Divider(
            height: 0,
            thickness: 1,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () async {
                final result =await FilePicker.platform.pickFiles();
                if(result==null){
                  return;
                }
                final file= result.files.first;
                await saveFile(file);
              },
              child: Row(
                children: [
                  SizedBox(width: 12,),
                  Icon(Icons.attachment),
                  SizedBox(width: 20,),
                  Text('Add attachment',style: TextStyle(color: Colors.grey[700],fontSize: 18),)
                ],
              ),
            ),
          ),
          Divider(
            height: 5,
            thickness: 1,
            color: Colors.grey[300],
          ),
          buildProgress(),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 40,
                width: 80,
                child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
                  onPressed: (){
                    if(progress==1.0){
                      MaterialInsert(widget.subject, widget.branch, widget.year, context);
                      Navigator.pop(context);
                    }else{
                      showToast();
                    }
                  },
                  child: Text('Post',style: TextStyle(fontSize: 17),),
                ),
              ),
              SizedBox(width: 20,)
            ],
          )
        ],
      ),
    );
  }
  Future saveFile(PlatformFile file) async{
    final path='files/${file!.name}';
    final newFile = File(file!.path!);
    final ref= FirebaseStorage.instance.ref().child(path);
    ref.putFile(newFile);
    setState((){
      uploadTask= ref.putFile(newFile);
      nameFile=file!.name;
    });
    final snapshot = await uploadTask!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
    setState((){
      uploadTask= null;
    });
  }
  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
    stream: uploadTask?.snapshotEvents,
    builder: (context,snapshot){
      if(snapshot.hasData){
        final data = snapshot.data!;
        progress = data.bytesTransferred / data.totalBytes;
        return SizedBox(
          height: 4,
          child: Stack(
            fit: StackFit.expand,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                color: Colors.red,
              )
            ],
          ),
        );
      }else{
         return Text('');
      }
    },
  );
  void showToast() =>
      Fluttertoast.showToast(
          msg: "Please wait",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
}
