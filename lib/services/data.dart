import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipic/Utils/Keys.dart';

class DataService{

  Future DataInsertUsers(String name, String email, String branch, String year, String admissionNo, BuildContext context) async {
    String baseUrl='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"users",
      "document":{
        "name":name,
        "email":email,
        "admission_no":admissionNo,
        "branch":branch,
        "year": year,
      }
    };
    HttpClient httpClient = HttpClient();
    HttpClientRequest httpClientRequest=await httpClient.postUrl(Uri.parse(baseUrl));
    httpClientRequest.headers.set("Content-Type", "application/json");
    httpClientRequest.headers.set("api-key", Keys().apiKey);
    httpClientRequest.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse response=await httpClientRequest.close();
    httpClient.close();
    final contents = StringBuffer();
    await for (var data in response.transform(utf8.decoder)) {
      contents.write(data);
    }
    var output=jsonDecode(contents.toString());
    if (kDebugMode) {
      print(output['insertedId']);
    }
  }
  Future DataInsertYearBranch(String name, String email, String branch, String year, String admissionNo, BuildContext context) async {
    String baseUrl='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"${year}_$branch",
      "document":{
        "name":name,
        "email":email,
        "admission_no":admissionNo,
      }
    };
    HttpClient httpClient = HttpClient();
    HttpClientRequest httpClientRequest=await httpClient.postUrl(Uri.parse(baseUrl));
    httpClientRequest.headers.set("Content-Type", "application/json");
    httpClientRequest.headers.set("api-key", Keys().apiKey);
    httpClientRequest.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse response=await httpClientRequest.close();
    httpClient.close();
    final contents = StringBuffer();
    await for (var data in response.transform(utf8.decoder)) {
      contents.write(data);
    }
    var output=jsonDecode(contents.toString());
    if (kDebugMode) {
      print(output['insertedId']);
    }
  }
  Future DataInsertAttendance(String admissionNo, String date, String time) async{
    String baseUrl='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"attendance",
      "collection":admissionNo,
      "document":{
        "date": date,
        "time": time,
      }
    };
    HttpClient httpClient=HttpClient();
    HttpClientRequest httpClientRequest=await httpClient.postUrl(Uri.parse(baseUrl));
    httpClientRequest.headers.set("Content-Type", "application/json");
    httpClientRequest.headers.set("api-key", Keys().apiKey);
    httpClientRequest.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse response=await httpClientRequest.close();
    httpClient.close();
    final contents = StringBuffer();
    await for (var data in response.transform(utf8.decoder)) {
      contents.write(data);
    }
    var output=jsonDecode(contents.toString());
    if (kDebugMode) {
      print(output['insertedId']);
    }
  }
}