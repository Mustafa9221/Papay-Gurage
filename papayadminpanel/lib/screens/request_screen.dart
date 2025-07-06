import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:papayadminpanel/MongoDb/mongoDbHelper.dart';
import 'package:papayadminpanel/MongoDb/requestgetter.dart';
import 'package:papayadminpanel/screens/messages_screen.dart';
import 'package:papayadminpanel/screens/messageshower.dart';
import 'package:papayadminpanel/screens/trackingTiles.dart';

class RequestScreen extends StatefulWidget {
  RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkIsDataLoaded();
  }

  void checkIsDataLoaded() async {
    while (FilterRequests.requested.isEmpty && !FilterRequests.loaded) {
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _data = FilterRequests.requested;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _data.isEmpty
              ? const Center(child: Text("No Request Found"))
              : SingleChildScrollView(
                  child: Wrap(
                    children: _data.map((req) {
                      return TrackingTile(
                        status: 0,
                        trackingId: req['trackingId'],
                        plateNo: req['plateNumber'].toString(),
                        phone: req['phone'].toString(),
                        qid: req['qid'].toString(),
                        description: req['problemDescription'],
                        location: req['location'].toString(),
                        pickup: req['pickupRequired'].toString(),
                        onAccept: () async {
                          final response = await Mongodbhelper().changeStatus(status: "inrepair", trackingId: req["trackingId"]);
                          if(response){
                            setState(() {
                              FilterRequests.inRepair.add(req);
                            _data.removeWhere((item) => item["trackingId"] == req["trackingId"]);
                            showCustomSnackBar(context, "Now the Request is in Repair");
                          });
                          }else{
                            showCustomSnackBar(context, "Unable to Send it to Repair");
                          }
                        },
                        onReject: () async{
                          final response = await Mongodbhelper().rejectRequest(trackingId: req["trackingId"]);
                          if(response){
                            showCustomSnackBar(context, "Unable to Delete");
                          }
                          showCustomSnackBar(context, "Deleted Successfuly");
                          setState(() {
                            _data.removeWhere((item) => item["trackingId"] == req["trackingId"]);
                          });
                        },
                        onMessages: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> MessagesScreen(trackingId: req["trackingId"])))
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
