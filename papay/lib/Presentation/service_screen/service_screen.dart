
import 'package:flutter/material.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Purple Image Section
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              gradient: LinearGradient(
                colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: null
            ),
          ),

          const SizedBox(height: 32),

          // Title
          const Text(
            'Easy Process',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Find all your house needs in one place. We provide every service to make your home experience smooth.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 32),


          const Spacer(),

          // Next Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 48,
                maxWidth: 600,
                minWidth: 400
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // next action
                },
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}
