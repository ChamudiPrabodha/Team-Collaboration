import 'package:flutter/material.dart';
import '../services/disease_service.dart';
import 'add_remedy_screen.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final String diseaseId;
  DiseaseDetailScreen({super.key, required this.diseaseId});

  final DiseaseService service = DiseaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Disease Details"),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: FutureBuilder(
        future: service.fetchDiseaseById(diseaseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load disease details',
                style: TextStyle(color: Colors.red[700]),
              ),
            );
          }
          if (snapshot.hasData) {
            final data = snapshot.data as Map<String, dynamic>;
            final remedies = data['remedies'] ?? [];

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] ?? 'Unknown Disease',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data['description'] ?? 'No description available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Remedies",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  remedies.isEmpty
                      ? Text(
                          'No remedies yet. Be the first to add one!',
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      : Expanded(
                          child: ListView.separated(
                            itemCount: remedies.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final remedy = remedies[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  title: Text(
                                    remedy['remedy'] ?? 'Unnamed Remedy',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    "By ${remedy['contributor'] ?? 'Unknown'}",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddRemedyScreen(diseaseId: diseaseId),
                        ),
                      ),
                      child: const Text(
                        "Add Remedy",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No data found.'));
        },
      ),
    );
  }
}
