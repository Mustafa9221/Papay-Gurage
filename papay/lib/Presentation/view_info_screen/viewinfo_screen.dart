import 'package:flutter/material.dart';
import 'package:papay/Bussiness/mongoDB/mongoDBService.dart';
import 'package:papay/Presentation/messages_screen/messages_screen.dart';
import 'package:papay/Presentation/widgets/messageshower.dart';

import 'package:flutter/material.dart';

class AppColors {
  static const lightGray = Color(0xFFF3F3F3);
  static const green = Color(0xFFB9FF66);
  static const dark = Color(0xFF191A23);
  static const border = Color(0xFF191A23);
  static const shadow = Color(0xFF191A23);
  static const black = Colors.black;
}

class InfoCard extends StatefulWidget {
  final Map<String, String> info;
  final String description;
  final String status;
  final VoidCallback onDelete;
  final VoidCallback onViewMessages;
  final String location;

  const InfoCard({
    super.key,
    required this.info,
    required this.description,
    required this.status,
    required this.onDelete,
    required this.onViewMessages,
    required this.location,
  });

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  bool _expanded = false;
  int? status;

  Color get textColor => status == 1 ? Colors.white : Colors.black;

  Widget _buildKeyValueRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              key,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == "request") {
      status = 0;
    } else if (widget.status == "inrepair") {
      status = 1;
    } else {
      status = 2;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: status == 0
            ? AppColors.lightGray
            : status == 1
                ? AppColors.black
                : AppColors.green,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status == 1 ? AppColors.green : AppColors.black,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.2),
            offset: const Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...widget.info.entries
                    .map((e) => _buildKeyValueRow(e.key, e.value)),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        "Description: ${widget.description}",
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Status: ${widget.status}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Text(
                      //   "Location: ${widget.location}",
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w600,
                      //     color: textColor,
                      //   ),
                      // ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: status==1?AppColors.lightGray:AppColors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: widget.onDelete,
                                icon: Icon(Icons.delete,
                                    color: status==1?AppColors.black:Colors.white),
                                label: Text("Delete",
                                    style: TextStyle(color: status==1?AppColors.black:Colors.white)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: status==2?AppColors.lightGray:AppColors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: widget.onViewMessages,
                                icon: Icon(Icons.message,
                                    color: AppColors.black),
                                label: Text("Messages",
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  crossFadeState: _expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class ViewInfoPage extends StatefulWidget {
  const ViewInfoPage({super.key});

  @override
  State<ViewInfoPage> createState() => _ViewInfoPageState();
}

class _ViewInfoPageState extends State<ViewInfoPage> {
  final MongoDbServices _mongoDbServices = MongoDbServices();

  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> filteredData = [];
  String searchText = "";
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchMongoData();
  }

  Future<void> fetchMongoData() async {
  setState(() {
    isLoading = true;
    error = null;
  });

  final result = await _mongoDbServices.getRequest(phone: "77957796");

  if (result['success'] == true) {
    final outerData = result['data'];

    if (outerData is Map<String, dynamic> &&
        outerData.containsKey('data') &&
        outerData['data'] is List) {
      List<dynamic> requestsList = outerData['data'];

      allData = requestsList.map<Map<String, dynamic>>((item) {
        return {
          "info": {
            "Tracking ID": item['trackingId'] ?? "N/A",
            "Plate No": item['plateNumber'] ?? "N/A",
            "Phone": item['phone'] ?? "N/A",
          },
          "description": item['problemDescription'] ?? "No description",
          "status": item['status'] ?? "N/A",
          "location": item["location"]?? "N/A"
        };
      }).toList();

      filteredData = allData;
    } else {
      error = "Data format error: 'data' key missing or invalid";
      allData = [];
      filteredData = [];
    }
  } else {
    error = result['message'] ?? "Failed to load data";
    allData = [];
    filteredData = [];
  }

  setState(() {
    isLoading = false;
  });
}


  void filterSearch(String query) {
  setState(() {
    searchText = query;
    if (query.isEmpty) {
      filteredData = allData;
    } else {
      filteredData = allData.where((item) {
        final tid = item["info"]["Tracking ID"]?.toString().toLowerCase() ?? "";
        return tid.contains(query.toLowerCase());
      }).toList();
    }
  });
}


  Future deleteItem(int index, trackingId) async{
    final response = await MongoDbServices().removeRequest(trackingId: trackingId);
        if(!response){
          showCustomSnackBar(context, "Unable to Delete");
          return ;
        }
    setState(() {
      allData.removeAt(index);
      filterSearch(searchText);
    });
  }

  void viewMessages(int index, trackingId) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> MessagesScreen(trackingId: trackingId,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        title: const Text("View Info"),
        backgroundColor: AppColors.dark,
        foregroundColor: Colors.white,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Search by any field",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: filterSearch,
                ),
              ),
              if (isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (error != null)
                Expanded(child: Center(child: Text(error!, style: const TextStyle(color: Colors.red))))
              else if (filteredData.isEmpty)
                const Expanded(child: Center(child: Text("No matching records found.")))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
                      return InfoCard(
                        info: Map<String, String>.from(item["info"]),
                        description: item["description"],
                        status: item["status"],
                        location: item["location"],
                        onDelete: () async{
                          final originalIndex = allData.indexOf(item);
                          await deleteItem(originalIndex,item["info"]["Tracking ID"]);
                        },
                        onViewMessages: () => viewMessages(index,item["info"]["Tracking ID"]),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
