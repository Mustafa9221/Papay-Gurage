import 'package:flutter/material.dart';
import 'package:papay/Presentation/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';



class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: AppColors.dark,
        foregroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.black54,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12)
          )
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 80, vertical: 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildContactCard(
                    context,
                    title: "Gmail",
                    icon: Icons.email,
                    info: "support@example.com",
                    url: "mailto:support@example.com",
                  ),
                  const SizedBox(height: 20),
                  _buildContactCard(
                    context,
                    title: "WhatsApp",
                    icon: Icons.whatshot,
                    info: "+123456789",
                    url: "https://wa.me/123456789",
                  ),
                  const SizedBox(height: 20),
                  _buildContactCard(
                    context,
                    title: "Phone",
                    icon: Icons.phone,
                    info: "+987654321",
                    url: "tel:+987654321",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context,
      {required String title,
      required IconData icon,
      required String info,
      required String url}) {
    return Card(
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(color: Colors.black, width: 1), // Black border here
  ),
      color: AppColors.lightGray,
      elevation: 4,
      shadowColor: AppColors.shadow.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not open $title')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  icon,
                  size: 36,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      info,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppColors.dark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
