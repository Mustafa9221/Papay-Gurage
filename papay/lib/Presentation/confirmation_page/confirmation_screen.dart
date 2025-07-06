import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  final String trackingId;
  final String name;
  final String phoneno;
  final String vechile;
  final String vecPlateNo;
  final String vehicleModel;
  final String color;
  final String description;
  final String location;
  final bool pickup;
  final String qid;

  const ConfirmationScreen({
    super.key,
    required this.trackingId,
    required this.name,
    required this.phoneno,
    required this.vechile,
    required this.vecPlateNo,
    required this.vehicleModel,
    required this.color,
    required this.description,
    required this.location,
    required this.pickup,
    required this.qid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Repair Request Info"),
        backgroundColor: const Color(0xFF191A23),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  infoRow("Tracking ID", trackingId),
                  infoRow("Name", name),
                  infoRow("Phone No", phoneno),
                  infoRow("QID", qid),
                  infoRow("Vehicle", vechile),
                  infoRow("Plate No", vecPlateNo),
                  infoRow("Model", vehicleModel),
                  infoRow("Color", color),
                  infoRow("Description", description),
                  infoRow("Location", location),
                  infoRow("Pickup", pickup ? "Yes" : "No"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for cleaner code
  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
