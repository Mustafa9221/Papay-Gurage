import 'package:flutter/material.dart';
import 'package:papay/Bussiness/mongoDB/mongoDBService.dart';
import 'package:papay/Presentation/confirmation_page/confirmation_screen.dart';
import 'package:papay/Presentation/home_screen/homeScreen.dart';
import 'package:papay/Presentation/messages_screen/messages_screen.dart';
import 'package:papay/Presentation/view_info_screen/viewinfo_screen.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome Mobile Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
