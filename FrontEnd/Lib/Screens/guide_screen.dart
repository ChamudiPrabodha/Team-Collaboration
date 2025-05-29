import 'package:flutter/material.dart';
import 'guide_detail_screen.dart';
import 'guide_form_screen.dart';
import '../services/guide_service.dart';

class GuideListScreen extends StatefulWidget {
  const GuideListScreen({super.key});

  @override
  State<GuideListScreen> createState() => _GuideListScreenState();
}

class _GuideListScreenState extends State<GuideListScreen> {
  late Future<List<Map<String, dynamic>>> _guides;

  @override
  void initState() {
    super.initState();
    _guides = fetchGuides();
  }

  Future<void> _refreshGuides() async {
    setState(() {
      _guides = fetchGuides();
    });
  }

  String getImageForGuide(Map<String, dynamic> guide) {
    final title = (guide['title'] ?? '').toString().toLowerCase();
    final category = (guide['category'] ?? '').toString().toLowerCase();

    if (title.contains('potato') || category.contains('potato')) {
      return 'https://upload.wikimedia.org/wikipedia/commons/6/60/Potato_Solanum_tuberosum.jpg';
    } else if (title.contains('tomato') || category.contains('tomato')) {
      return 'https://upload.wikimedia.org/wikipedia/commons/8/88/Bright_red_tomato_and_cross_section02.jpg';
    } else if (title.contains('corn') || category.contains('corn')) {
      return 'https://upload.wikimedia.org/wikipedia/commons/4/4c/Corncobs.jpg';
    } else if (title.contains('carrot') || category.contains('carrot')) {
      return 'https://upload.wikimedia.org/wikipedia/commons/7/7e/CarrotHarvest.jpg';
    } else {
      return guide['image'] ?? 'https://via.placeholder.com/300x200.png?text=No+Image';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Farming Guides'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _guides,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final guides = snapshot.data!;
          if (guides.isEmpty) {
            return const Center(child: Text('No guides available'));
          }

          return RefreshIndicator(
            onRefresh: _refreshGuides,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: guides.length,
              itemBuilder: (context, index) {
                final guide = guides[index];
                final imageUrl = getImageForGuide(guide);

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GuideDetailScreen(guideId: guide['id']),
                      ),
                    );
                    _refreshGuides();
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: Image.network(
                            imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guide['title'] ?? 'Untitled',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                guide['category'] ?? 'Unknown Category',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GuideFormScreen()),
          );
          _refreshGuides();
        },
      ),
    );
  }
}
