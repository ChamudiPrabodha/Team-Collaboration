import 'package:flutter/material.dart';
import '../services/forums_service.dart';

class CreateForumScreen extends StatefulWidget {
  final String currentUser; // Receive the username

  const CreateForumScreen({super.key, required this.currentUser});

  @override
  State<CreateForumScreen> createState() => _CreateForumScreenState();
}

class _CreateForumScreenState extends State<CreateForumScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitForum() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await ForumService.createForum(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        author: {"name": widget.currentUser}, // use passed-in username
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Forum created successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create forum')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Forum'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/a.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _titleController,
                    label: "Title",
                    validatorMsg: "Title is required",
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _contentController,
                    label: "Content",
                    maxLines: 5,
                    validatorMsg: "Content is required",
                  ),
                  const SizedBox(height: 30),
                  _isSubmitting
                      ? const CircularProgressIndicator(
                          color: Colors.greenAccent,
                        )
                      : ElevatedButton(
                          onPressed: _submitForum,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            shadowColor: Colors.greenAccent,
                          ),
                          child: const Text(
                            "Create Forum",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
              if (value == null || value.trim().isEmpty) return validatorMsg;
              return null;
            },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green[100]),
        filled: true,
        fillColor: Colors.black54,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
