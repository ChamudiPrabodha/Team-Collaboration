import 'package:flutter/material.dart';
import 'package:govi_arana/screens/crop_screen.dart';
import 'package:govi_arana/screens/forums_screen.dart';
import 'package:govi_arana/screens/prediction_screen.dart';
import 'package:govi_arana/screens/profile_screen.dart';
import 'package:govi_arana/screens/rental_screen.dart';
import 'package:govi_arana/screens/voice_screen.dart';
import 'disease_screen.dart';
import 'guide_screen.dart';
import 'location.dart';



class DashboardScreen extends StatelessWidget {
  final String userId;
  final String userName;
  final String email;
  final String? profileImageUrl;
  final String authToken; // <-- Add this

  const DashboardScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.email,
    this.profileImageUrl,
    required this.authToken, // <-- Add this
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome, $userName")),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: profileImageUrl != null && profileImageUrl!.isNotEmpty
                    ? NetworkImage(profileImageUrl!)
                    : const AssetImage('assets/images.jpeg') as ImageProvider,
              ),
              decoration: const BoxDecoration(color: Colors.green),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("My Profile"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                    email: email,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About Us"),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("Feedback"),
              onTap: () => Navigator.pushNamed(context, '/feedback'),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Help"),
              onTap: () => Navigator.pushNamed(context, '/help'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildCard(context, "Diseases", DiseaseListScreen(), 'assets/diseases.webp'),
              _buildCard(context, "Guide", GuideListScreen(), 'assets/guides.jpg'),
              _buildCard(context, "Rentals and Bookings", MachineListScreen(), 'assets/machines.jpg'),
              _buildCard(context, "Forum", ForumListScreen(), 'assets/logo.PNG', routeName: '/forum'),
              _buildCard(context, "Location", LocationScreen(), 'assets/location.png'),
              _buildCard(context, "My Crops", CropsScreen(authToken: '',), 'assets/mycrops.jpg'),
              _buildCard(context, "AI Disease Detection", PredictScreen(), 'assets/a.jpg'),

              // Added AI Voice Typing screen card here
              _buildCard(context, "AI Voice Typing", const AIWithVoiceInputScreen(), 'assets/a.jpg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    Widget? screen,
    String imagePath, {
    String? routeName,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (routeName != null) {
            Navigator.pushNamed(context, routeName);
          } else if (screen != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
