import 'package:flutter/material.dart';
import '../services/disease_service.dart';

class AddDiseaseScreen extends StatefulWidget {
  const AddDiseaseScreen({super.key});

  @override
  State<AddDiseaseScreen> createState() => _AddDiseaseScreenState();
}

class _AddDiseaseScreenState extends State<AddDiseaseScreen> {
  final DiseaseService service = DiseaseService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _imgUrlController = TextEditingController();
  final _identifiedByController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await service.createDisease({
        "name": _nameController.text,
        "description": _descController.text,
        "imageUrl": _imgUrlController.text,
        "identifiedBy": _identifiedByController.text,
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _imgUrlController.dispose();
    _identifiedByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Disease"),
        backgroundColor: Colors.green[700],
        elevation: 4,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/a.jpg', // your background image path
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Disease Name',
                    validatorMsg: 'Please enter disease name',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _descController,
                    label: 'Description',
                    validatorMsg: 'Please enter description',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _imgUrlController,
                    label: 'Image URL',
                    validatorMsg: 'Please enter image URL',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _identifiedByController,
                    label: 'Identified By',
                    validatorMsg: 'Please enter identifier',
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Colors.greenAccent,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? validatorMsg,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      validator: validatorMsg == null
          ? null
          : (value) {
              if (value == null || value.isEmpty) return validatorMsg;
              return null;
            },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green[100]),
        filled: true,
        fillColor: Colors.black54,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.green.shade300, width: 2),
        ),
      ),
    );
  }
}
