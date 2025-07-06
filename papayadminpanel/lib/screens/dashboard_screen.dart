import 'package:flutter/material.dart';
import 'package:papayadminpanel/MongoDb/requestgetter.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardData = [
      {
        'title': 'New Requests',
        'count': FilterRequests.requested.length.toString(),
        'icon': Icons.assignment,
        'color': Colors.blueAccent
      },
      {
        'title': 'In Repair',
        'count': FilterRequests.inRepair.length.toString(),
        'icon': Icons.build_circle_outlined,
        'color': Colors.orangeAccent
      },
      {
        'title': 'Completed',
        'count': FilterRequests.completed.length.toString(),
        'icon': Icons.check_circle_outline,
        'color': Colors.green
      },
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin 👋',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: cardData.map((data) {
                  return DashboardCard(
                    title: data['title'] as String,
                    count: data['count'] as String,
                    icon: data['icon'] as IconData,
                    color: data['color'] as Color,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
