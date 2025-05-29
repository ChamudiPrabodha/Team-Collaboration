import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateProductivityScreen extends StatefulWidget {
  final Map<String, dynamic> crop;
  const UpdateProductivityScreen({super.key, required this.crop});

  @override
  _UpdateProductivityScreenState createState() =>
      _UpdateProductivityScreenState();
}

class _UpdateProductivityScreenState extends State<UpdateProductivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productivityController = TextEditingController();

  Future<void> _update() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(
        'http://localhost:3000/crops/${widget.crop['id']}/productivity',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"productivity": _productivityController.text}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Productivity updated')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update productivity')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _productivityController.text = widget.crop['productivity'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Productivity')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Crop: ${widget.crop['cropName']}'),
              TextFormField(
                controller: _productivityController,
                decoration: InputDecoration(labelText: 'Productivity'),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? 'Enter productivity'
                            : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _update, child: Text('Update')),
            ],
          ),
        ),
      ),
    );
  }
}
