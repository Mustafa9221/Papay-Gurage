import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String code;
  final Gradient gradient;
  final String? imageUrl;

  const OfferCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.code,
    required this.gradient,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: title.length > 10 ? 20 : 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                code,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 11,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          if (imageUrl != null)
            Positioned(
              right: -10,
              top: 10,
              child: SizedBox(
                width: 80,
                height: 80,
                child: ClipOval(
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
