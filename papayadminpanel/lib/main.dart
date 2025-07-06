
import 'package:flutter/material.dart';
import 'package:papayadminpanel/MongoDb/mongoDbHelper.dart';
import 'package:papayadminpanel/MongoDb/requestgetter.dart';
import 'package:papayadminpanel/screens/home_screen.dart';

void main(){
  runApp(
    MainWidget(),
  );
  Requestgetter.fetchRequests();
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}