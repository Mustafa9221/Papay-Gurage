import 'package:flutter/material.dart';
import 'package:papayadminpanel/MongoDb/requestgetter.dart';
import 'package:papayadminpanel/screens/trackingTiles.dart';

class CompletedScreen extends StatefulWidget {
  CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkIsDataLoaded();
  }

  void checkIsDataLoaded() async {
    while (FilterRequests.completed.isEmpty && !FilterRequests.loaded) {
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _data = FilterRequests.completed;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _data.isEmpty
              ? const Center(child: Text("No Request Found"))
              : SingleChildScrollView(
                  child: Wrap(
                    children: _data.map((req) {
                      return TrackingTile(
                        status: 2,
                        trackingId: req['trackingId'],
                        plateNo: req['plateNumber'].toString(),
                        phone: req['phone'].toString(),
                        qid: req['qid'].toString(),
                        description: req['problemDescription'],
                        location: req['location'].toString(),
                        pickup: req['pickupRequired'].toString(),
                        onAccept: () => print("Accepted ${req['trackingId']}"),
                        onReject: () => print("Rejected ${req['trackingId']}"),
                        onMessages: () => print("Open Messages for ${req['trackingId']}"),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
