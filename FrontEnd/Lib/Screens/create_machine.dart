import 'package:flutter/material.dart';
import 'package:govi_arana/services/rental_service.dart';

class ListMachineScreen extends StatefulWidget {
  const ListMachineScreen({super.key});

  @override
  _ListMachineScreenState createState() => _ListMachineScreenState();
}

class _ListMachineScreenState extends State<ListMachineScreen> {
  final _formKey = GlobalKey<FormState>();
  final RentalService service = RentalService();

  final ownerIdController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void dispose() {
    ownerIdController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final machineId = await service.listMachine({
          'ownerId': ownerIdController.text,
          'title': titleController.text,
          'description': descriptionController.text,
          'pricePerDay': double.parse(priceController.text),
          'location': locationController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Machine listed with ID: $machineId')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error listing machine: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List New Machine')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'List Your Machine',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    _buildTextField(ownerIdController, 'Owner ID'),
                    SizedBox(height: 16),
                    _buildTextField(titleController, 'Title'),
                    SizedBox(height: 16),
                    _buildTextField(descriptionController, 'Description'),
                    SizedBox(height: 16),
                    _buildTextField(
                      priceController,
                      'Price Per Day',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(locationController, 'Location'),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submit,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'List Machine',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return 'Required';
        if (label == 'Price Per Day' && double.tryParse(val) == null) {
          return 'Enter valid number';
        }
        return null;
      },
    );
  }
}
