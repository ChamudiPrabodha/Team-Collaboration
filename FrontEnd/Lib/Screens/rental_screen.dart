import 'package:flutter/material.dart';
import 'package:govi_arana/services/rental_service.dart';

class MachineListScreen extends StatefulWidget {
  const MachineListScreen({super.key});

  @override
  _MachineListScreenState createState() => _MachineListScreenState();
}

class _MachineListScreenState extends State<MachineListScreen> {
  final RentalService service = RentalService();
  late Future<List<dynamic>> machines;

  @override
  void initState() {
    super.initState();
    machines = service.getMachines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Machines'),
        backgroundColor: const Color.fromARGB(255, 18, 21, 18),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/list-machine'),
          ),
          IconButton(
            icon: const Icon(Icons.book_online),
            onPressed: () => Navigator.pushNamed(context, '/bookings'),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/background.jpeg',
            ), // ensure this image is in pubspec.yaml
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: machines,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final machines = snapshot.data!;
            if (machines.isEmpty) {
              return const Center(child: Text('No machines available'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: machines.length,
              itemBuilder: (context, index) {
                final machine = machines[index];
                return Card(
                  color: Colors.white.withOpacity(0.9),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          machine['title'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          machine['description'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Price: \$${machine['pricePerDay']}/day',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                18,
                                21,
                                18,
                              ),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/bookings',
                                arguments: machine,
                              );
                            },
                            child: const Text("Book"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
