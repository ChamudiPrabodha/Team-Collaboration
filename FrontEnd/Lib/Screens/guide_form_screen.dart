import 'package:flutter/material.dart';
import '../services/guide_service.dart';

class GuideFormScreen extends StatefulWidget {
  final String? guideId;
  final Map<String, dynamic>? initialData;

  const GuideFormScreen({super.key, this.guideId, this.initialData});

  @override
  _GuideFormScreenState createState() => _GuideFormScreenState();
}

class _GuideFormScreenState extends State<GuideFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData?['title']);
    _contentController = TextEditingController(text: widget.initialData?['content']);
    _categoryController = TextEditingController(text: widget.initialData?['category']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _saveGuide() async {
    if (_formKey.currentState!.validate()) {
      final guide = {
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'category': _categoryController.text.trim(),
      };
      if (widget.guideId == null) {
        await addGuide(guide);
      } else {
        await updateGuide(widget.guideId!, guide);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.guideId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Guide' : 'Add Guide'),
        backgroundColor: Colors.green[700],
        elevation: 4,
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/a.jpg', // replace with your image path
            fit: BoxFit.cover,
          ),

          // Semi-transparent overlay for readability
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Form content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _titleController,
                    label: 'Title',
                    validatorMsg: 'Please enter a title',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _contentController,
                    label: 'Content',
                    maxLines: 6,
                    validatorMsg: 'Please enter the content',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _categoryController,
                    label: 'Category (optional)',
                    validatorMsg: null,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveGuide,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                        shadowColor: Colors.greenAccent,
                      ),
                      child: Text(
                        isEditing ? 'Update Guide' : 'Create Guide',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
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
      validator: validatorMsg == null
          ? null
          : (value) {
              if (value == null || value.trim().isEmpty) return validatorMsg;
              return null;
            },
      style: const TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: Colors.greenAccent,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green[100], fontWeight: FontWeight.w600),
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
