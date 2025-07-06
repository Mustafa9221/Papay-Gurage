import 'package:flutter/material.dart';
import 'package:papay/Presentation/contact_page/contact_page.dart';
import 'package:papay/Presentation/request_repair_screen/request_repair_screen.dart';
import 'package:papay/Presentation/theme/colors.dart';
import 'package:papay/Presentation/view_info_screen/viewinfo_screen.dart';

class AppColors {
  static const lightGray = Color(0xFFF3F3F3);
  static const green = Color(0xFFB9FF66);
  static const dark = Color(0xFF191A23);
  static const border = Color(0xFF191A23);
  static const shadow = Color(0xFF191A23);
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String buttonText;
  final Color backgroundColor;
  final Color labelColor;
  final Color textColor;

  const ServiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonText,
    required this.backgroundColor,
    required this.labelColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.2),
            offset: const Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(title),
            const SizedBox(height: 8),
            _buildLabel(subtitle),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: MyColors.black),
                  color: Colors.grey[300],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              alignment: Alignment.bottomRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: labelColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: textColor),
                  ),
                  onPressed: () {
                    final page;
                    switch(buttonText){
                      case "Request Repair": page=RequestRepairPage();
                      break;
                      case "View Info": page = ViewInfoPage();
                      break;
                      default: page = ContactUsPage();
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> page));
                  },
                  child: Text(buttonText, style: TextStyle(color: textColor)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: labelColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final services = _getDummyData();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 80, vertical: 40),
        child: Column(
          children: [
            Center(
              child: Text(
                "Choose a Service",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.dark,
                ),
              ),
            ),
            SizedBox(height: 20),
            isMobile ? _buildMobileLayout(services) : _buildDesktopLayout(services),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(List<Map<String, dynamic>> services) {
    return Column(
      children: services.map((service) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ServiceCard(
            title: service['title']!,
            subtitle: service['subtitle']!,
            description: service['description']!,
            buttonText: service['buttonText']!,
            backgroundColor: service['backgroundColor']!,
            labelColor: service['labelColor']!,
            textColor: service['textColor']!,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDesktopLayout(List<Map<String, dynamic>> services) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ServiceCard(
                title: services[0]['title']!,
                subtitle: services[0]['subtitle']!,
                description: services[0]['description']!,
                buttonText: services[0]['buttonText']!,
                backgroundColor: services[0]['backgroundColor']!,
                labelColor: services[0]['labelColor']!,
                textColor: services[0]['textColor']!,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ServiceCard(
                title: services[1]['title']!,
                subtitle: services[1]['subtitle']!,
                description: services[1]['description']!,
                buttonText: services[1]['buttonText']!,
                backgroundColor: services[1]['backgroundColor']!,
                labelColor: services[1]['labelColor']!,
                textColor: services[1]['textColor']!,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ServiceCard(
                title: services[2]['title']!,
                subtitle: services[2]['subtitle']!,
                description: services[2]['description']!,
                buttonText: services[2]['buttonText']!,
                backgroundColor: services[2]['backgroundColor']!,
                labelColor: services[2]['labelColor']!,
                textColor: services[2]['textColor']!,
              ),
            ),
            const SizedBox(width: 20),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getDummyData() {
    return [
      {
        'title': 'Papay',
        'subtitle': 'Repair Service',
        'description': "Quick and reliable repair services to get your car back in perfect condition.",
        'buttonText': 'Request Repair',
        'backgroundColor': AppColors.lightGray,
        'labelColor': AppColors.green,
        'textColor': Colors.black,
      },
      {
        'title': 'Repair',
        'subtitle': 'Information',
        'description': "Get info about your repair requests and service history.",
        'buttonText': 'View Info',
        'backgroundColor': AppColors.green,
        'labelColor': Colors.white,
        'textColor': Colors.black,
      },
      {
        'title': 'Contact',
        'subtitle': 'Us',
        'description': "Have any questions? Our support team is ready to assist you anytime.",
        'buttonText': 'Contact Support',
        'backgroundColor': AppColors.dark,
        'labelColor': AppColors.green,
        'textColor': Colors.black,
      },
    ];
  }
}
