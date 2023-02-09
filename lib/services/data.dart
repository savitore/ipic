import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataService{

  Future DataInsertUsers(String name, String email, String branch, String year, String admission_no, BuildContext context) async {
    String baseUrl='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"users",
      "document":{
        "name":name,
        "email":email,
        "admission_no":admission_no,
        "branch":branch,
        "year": year,
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
  Future DataInsertYearBranch(String name, String email, String branch, String year, String admission_no, BuildContext context) async {
    String baseUrl='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":year+"_"+branch,
      "document":{
        "name":name,
        "email":email,
        "admission_no":admission_no,
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
  Future DataInsertAttendance(String admission_no, String date, String time) async{
    String baseUrl='https://data.mongodb-api.com/app/data-kwvwd/endpoint/data/v1/action/insertOne';
    final body={
      "dataSource":"Cluster0",
      "database":"attendance",
      "collection":admission_no,
      "document":{
        "date": date,
        "time": time,
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
}