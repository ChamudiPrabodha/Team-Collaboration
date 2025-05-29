import 'package:flutter/material.dart';
import '../services/disease_service.dart';

class AddRemedyScreen extends StatefulWidget {
  final String diseaseId;

  const AddRemedyScreen({super.key, required this.diseaseId});

  @override
  State<AddRemedyScreen> createState() => _AddRemedyScreenState();
}

class _AddRemedyScreenState extends State<AddRemedyScreen> {
  final DiseaseService service = DiseaseService();

  final _remedyController = TextEditingController();
  final _contributorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await service.addRemedy(widget.diseaseId, {
        "remedy": _remedyController.text,
        "contributor": _contributorController.text,
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _remedyController.dispose();
    _contributorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Remedy"),
        backgroundColor: Colors.green[700],
        elevation: 4,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/a.jpg', // your background image
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
                    controller: _remedyController,
                    label: 'Remedy',
                    validatorMsg: 'Please enter a remedy',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _contributorController,
                    label: 'Contributor',
                    validatorMsg: 'Please enter contributor name',
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
