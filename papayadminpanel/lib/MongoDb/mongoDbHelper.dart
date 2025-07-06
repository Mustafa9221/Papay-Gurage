import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:papayadminpanel/MongoDb/mongodb_key.dart';

class Mongodbhelper {

  Future<Map<String, dynamic>> getRequests() async {
  try {
    final response = await http.get(
      Uri.parse("${MongoDB.api}getallRequests")
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Check if the response includes success flag or error message
      if (data is Map<String, dynamic>) {
        if (data.containsKey('success') && data['success'] == false) {
          // Backend sent a failure message
          return {
            'success': false,
            'message': data['message'] ?? 'Unknown error from server',
          };
        } else {
          // Success response with data
          return {
            'success': true,
            'data': data,
          };
        }
      } else {
        // If response is not a Map (e.g. a List), just return success with data
        return {
          'success': true,
          'data': data,
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Server error: ${response.statusCode}',
      };
    }
  } catch (e) {
    print(e.toString());
    return {
      'success': false,
      'message': 'Failed to fetch data: ${e.toString()}',
    };
  }
}

Future rejectRequest({required trackingId}) async{
  try{
    final response = await http.post(
      Uri.parse("${MongoDB.api}removeRequest"),
      headers: {"Content-Type": "Application/json"},
      body: jsonEncode({
        "trackingId": trackingId
      })
    );
    if(response.statusCode==200){
      return true;
    }
    return false;
  }catch(e){
    print(e.toString());
    return false;
  }
}

Future<bool> changeStatus({required status,required trackingId}) async{
  try{
    final response = await http.post(
      Uri.parse("${MongoDB.api}changeStatus"),
      headers: {"Content-Type": "Application/json"},
      body: jsonEncode({
        'status': status,
        'trackingId': trackingId
      })
    );
    if(response.statusCode==200){
      return true;
    }
    return false;
  }catch(e){
    print(e.toString());
    return false;
  }
}
}