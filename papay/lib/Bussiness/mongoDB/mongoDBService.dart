import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:papay/Bussiness/mongoDB/mongodb_key.dart';

class MongoDbServices {
  Future<List<dynamic>> addRepairRequest({
    required String name,
    required String phoneNo,
    required String qid,
    required String vecPlateNo,
    required String vecModel,
    required String color,
    required String description,
    required String location,
    required bool pickup,
     required String vechile,
  }) async {
    final Map<String, dynamic> data = {
      'status': "request",
      'name': name,
      'phone': phoneNo,
      'qid': qid,
      'plateNumber': vecPlateNo,
      'vechile': vechile,
      'vehicleModel': vecModel,
      'color': color,
      'problemDescription': description,
      'location': location,
      'pickupRequired': pickup,
    };

    try {
      final response = await http.post(
        Uri.parse("${MongoDB.api}repairRequest"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return [true, body['message'] ?? "Request submitted successfully",body["trackingId"],];
      } else {
        final body = jsonDecode(response.body);
        return [false, body['error'] ?? "Something went wrong"];
      }
    } catch (e) {
      return [false, "Network error: ${e.toString()}"];
    }
  }



  Future<Map<String, dynamic>> getRequest({required String phone}) async {
  try {
    final response = await http.get(
      Uri.parse("${MongoDB.api}getRequests?phone=$phone"),
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


  Future removeRequest({required trackingId}) async{
    try{
     final response= await http.post(Uri.parse("${MongoDB.api}removeRequest"),
      headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"trackingId": trackingId}),
      );
      print(response.body);
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
