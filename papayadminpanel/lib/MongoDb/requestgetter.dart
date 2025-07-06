import 'package:papayadminpanel/MongoDb/mongoDbHelper.dart';

class Requestgetter {
  static fetchRequests() async{
    final response = await Mongodbhelper().getRequests();
    if(response["success"]){
      FilterRequests().filterData(response["data"]["data"]);
    }
  }
}


class FilterRequests{
  static List requested = [];
  static List inRepair=[];
  static List completed=[];
  static bool loaded=false;
  void filterData(data){
    for (var item in data) {
      if (item["status"] == "request") {
        requested.add(item);
      }else if(item["status"]=='inrepair'){
        inRepair.add(item);
      }else{
        completed.add(item);
      }
    }
    loaded=true;
  }
}
