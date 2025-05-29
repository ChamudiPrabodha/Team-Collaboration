import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/logo.PNG',
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 82, 177, 119).withOpacity(0.88),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Govi Arana',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 11, 11, 11),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Govi Arana is a comprehensive digital platform designed to transform the agricultural experience for farmers across regions. We are committed to integrating traditional farming practices with modern technology to enhance productivity, reduce risks, and promote sustainability in agriculture.',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '🌾 Our Key Services:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '• **Disease Detection:** Farmers can identify plant diseases early using image-based tools and receive expert advice on treatment.\n\n'
                    '• **Cultivation Guides:** Access crop-specific guidance for every stage of growth—soil prep, irrigation, fertilization, harvesting, and more.\n\n'
                    '• **Farming Equipment Rentals:** Find and rent modern agricultural machines tailored to your specific needs, improving efficiency and reducing labor.\n\n'
                    '• **Location-Based Services:** Discover nearby agricultural markets, suppliers, clinics, and service centers using GPS-enabled features.\n\n'
                    '• **Expert Consultation:** Interact with certified agronomists and receive personalized solutions for complex issues.\n\n'
                    '• **Weather & Alerts:** Get real-time weather forecasts and alerts to make informed decisions on planting and irrigation.\n\n'
                    '• **Guide Repository:** Browse and read visual guides and tutorials created by farming experts and fellow farmers.\n\n'
                    '• **Community Support:** Engage with other farmers via forums, share experiences, and solve problems together.',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '🚜 Our Mission:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'To revolutionize farming through knowledge, technology, and accessibility. We aim to empower every farmer—regardless of size or location—with the tools they need to thrive in a changing world.',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '🌍 Impact & Reach:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Our platform is already making a difference by reducing crop loss, increasing yields, and building digitally connected farming communities. With multilingual support and regional customization, we ensure that every farmer feels at home with Govi Arana.',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Thank you for being part of our mission to create a smarter, more resilient farming future.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 3, 42, 2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
