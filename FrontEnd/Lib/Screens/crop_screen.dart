import 'package:flutter/material.dart';
import 'package:govi_arana/services/crops_service.dart';
import 'package:intl/intl.dart';


class CropsScreen extends StatefulWidget {
  final String authToken;

  const CropsScreen({super.key, required this.authToken});

  @override
  State<CropsScreen> createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  late CropService _cropService;
  List<dynamic> _crops = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cropService = CropService(widget.authToken);
    _fetchCrops();
  }

  Future<void> _fetchCrops() async {
    setState(() => _isLoading = true);
    try {
      final crops = await _cropService.getCropsByUser();
      setState(() => _crops = crops);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching crops: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addCrop() async {
    final cropData = {
      'cropName': _cropNameController.text.trim(),
      'type': _typeController.text.trim(),
      'plantingDate': DateTime.now().toIso8601String(),
      'location': _locationController.text.trim(),
    };

    if (cropData.values.any((value) => value.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final success = await _cropService.addCrop(cropData);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crop added successfully')),
      );
      _cropNameController.clear();
      _typeController.clear();
      _locationController.clear();
      _fetchCrops();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add crop')),
      );
    }
  }

  void _showUpdateDialog(String cropId) {
    final stageController = TextEditingController();
    final productivityController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Crop'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stageController,
              decoration: const InputDecoration(labelText: 'New Growth Stage'),
            ),
            TextField(
              controller: productivityController,
              decoration: const InputDecoration(labelText: 'Productivity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final stage = stageController.text.trim();
              final productivity = productivityController.text.trim();

              if (stage.isNotEmpty) {
                await _cropService.updateGrowthStage(cropId, stage);
              }
              if (productivity.isNotEmpty) {
                await _cropService.updateProductivity(cropId, productivity);
              }

              Navigator.pop(context);
              _fetchCrops();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Crops'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchCrops,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: _cropNameController,
                    decoration: const InputDecoration(labelText: 'Crop Name'),
                  ),
                  TextField(
                    controller: _typeController,
                    decoration: const InputDecoration(labelText: 'Type'),
                  ),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addCrop,
                    child: const Text('Add Crop'),
                  ),
                  const Divider(height: 30),
                  const Text(
                    'Your Crops:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ..._crops.map((crop) => Card(
                        child: ListTile(
                          title: Text(crop['cropName'] ?? ''),
                          subtitle: Text(
                            'Type: ${crop['type']}, Location: ${crop['location']}\n'
                            'Planted on: ${DateFormat.yMMMd().format(DateTime.parse(crop['plantingDate']))}\n'
                            'Stage: ${crop['growthStage']} | Productivity: ${crop['productivity'] ?? 'N/A'}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showUpdateDialog(crop['id']),
                          ),
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
