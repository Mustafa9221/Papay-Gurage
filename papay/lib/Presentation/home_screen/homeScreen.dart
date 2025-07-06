import 'package:flutter/material.dart';
import 'package:papay/Presentation/service_screen/service_screen.dart';
import 'package:papay/Presentation/widgets/service_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ServicesSection(),
    );
  }
}