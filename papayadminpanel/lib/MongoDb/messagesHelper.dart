import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:papayadminpanel/MongoDb/mongodb_key.dart';

class Messageshelper {
  Future<List> fetchMessages({required trackingId}) async{
    try{
      final response = await http.get(
        Uri.parse("${MongoDB.api}getMessages?trackingId=$trackingId")
      );
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        return [true,data["messages"]];
      }
      return [false];
    }catch(e){
      return [false];
    }
  }

  Future<List> sendMessage({required message,required trackingId}) async{
    final timestamp = DateTime.now().toString();
    final data = {
          'trackingId': trackingId,
          'author': "admin",
          'timestamp': timestamp,
          'message': message
        };
    try{
      final response = await http.post(
        Uri.parse("${MongoDB.api}sendMessage"),
        headers: {'Content-Type': "Application/json"},
        body: jsonEncode(data)
      );
      print(response);
      if(response.statusCode==200)
      {
        print("messageSaved");
        return [true,data];
      }
      return [false];
    }catch(e){
      print(e.toString());
      return [false]; 
    }
  }
}