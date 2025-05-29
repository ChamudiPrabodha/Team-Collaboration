import 'package:flutter/material.dart';
import '../services/disease_service.dart';
import 'disease_detail_screen.dart';
import 'add_disease_screen.dart';

class DiseaseListScreen extends StatefulWidget {
  const DiseaseListScreen({super.key});

  @override
  _DiseaseListScreenState createState() => _DiseaseListScreenState();
}

class _DiseaseListScreenState extends State<DiseaseListScreen> {
  final DiseaseService service = DiseaseService();
  late Future<List<dynamic>> diseases;

  @override
  void initState() {
    super.initState();
    diseases = service.fetchAllDiseases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diseases"),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: diseases,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: Colors.red[700]),
              ),
            );
          }
          if (snapshot.hasData) {
            final diseasesList = snapshot.data!;
            if (diseasesList.isEmpty) {
              return const Center(
                child: Text(
                  'No diseases found.\nAdd a new one using the + button.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: diseasesList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final disease = diseasesList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    title: Text(
                      disease['name'] ?? 'Unnamed Disease',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      disease['description'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DiseaseDetailScreen(diseaseId: disease['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No data found.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddDiseaseScreen()),
        ),
        tooltip: 'Add Disease',
        child: const Icon(Icons.add),
      ),
    );
  }
}
