import 'package:flutter/material.dart';

// Help Screen with styled UI
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHelpCard(
              icon: Icons.phone,
              title: 'Contact Support',
              subtitle: '+1 234 567 8900',
              color: Colors.green[100]!,
            ),
            const SizedBox(height: 16),
            _buildHelpCard(
              icon: Icons.email,
              title: 'Email Us',
              subtitle: 'support@goviarana.com',
              color: Colors.green[50]!,
            ),
            const SizedBox(height: 16),
            _buildHelpCard(
              icon: Icons.link,
              title: 'Visit Website',
              subtitle: 'www.goviarana.com',
              color: Colors.green[100]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: Colors.green[700],
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // Optional: implement navigation or actions here
        },
      ),
    );
  }
}
