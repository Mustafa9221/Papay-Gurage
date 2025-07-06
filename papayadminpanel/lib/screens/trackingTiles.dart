
import 'package:flutter/material.dart';

class TrackingTile extends StatefulWidget {
  final String trackingId;
  final String plateNo;
  final String phone;
  final String qid;
  final String description;
  final String location;
  final String pickup;
  final int status;

  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onMessages;

  const TrackingTile({
    super.key,
    required this.status,
    required this.trackingId,
    required this.plateNo,
    required this.phone,
    required this.qid,
    required this.description,
    required this.location,
    required this.pickup,
    required this.onAccept,
    required this.onReject,
    required this.onMessages,
  });

  @override
  State<TrackingTile> createState() => _TrackingTileState();
}

class _TrackingTileState extends State<TrackingTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 2)),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Top Info in two columns
              Column(
                children: [
                  _buildDualInfo("Tracking ID", widget.trackingId, "Plate No", widget.plateNo),
                  _buildDualInfo("Phone", widget.phone, "QID", widget.qid),
                ],
              ),

              // Expandable Section
              AnimatedCrossFade(
                crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      _buildSingleInfo("Description", widget.description),
                      _buildSingleInfo("Location", widget.location),
                      _buildSingleInfo("Pickup", widget.pickup),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: widget.onReject,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.cancel,color: Colors.black,),
                                label: const Text("Reject",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: widget.onAccept,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.check,color: Colors.black,),
                                label: Text(widget.status==1?"Repaired":"Accept",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: widget.onMessages,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.message,color: Colors.black,),
                                label: const Text("Messages",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDualInfo(String title1, String value1, String title2, String value2) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildLabeledValue(title1, value1)),
            const SizedBox(width: 8),
            Expanded(child: _buildLabeledValue(title2, value2)),
          ],
        ),
        const Divider(thickness: 1, color: Colors.grey),
      ],
    );
  }

  Widget _buildSingleInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabeledValue(title, value),
        const Divider(thickness: 1, color: Colors.grey),
      ],
    );
  }

  Widget _buildLabeledValue(String title, String value) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
        children: [
          TextSpan(text: "$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
