import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/prediction_service.dart';

class PredictScreen extends StatefulWidget {
  const PredictScreen({super.key});

  @override
  _PredictScreenState createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  File? _imageFile;
  Uint8List? _webImageBytes;
  String? _prediction;
  double? _confidence;
  bool _loading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _imageFile = null;
          _prediction = null;
          _confidence = null;
        });
      } else {
        final file = File(pickedFile.path);
        setState(() {
          _imageFile = file;
          _webImageBytes = null;
          _prediction = null;
          _confidence = null;
        });
      }
    }
  }

  Future<void> _predict() async {
    if (_imageFile == null && _webImageBytes == null) return;

    setState(() => _loading = true);

    try {
      Map<String, dynamic> result;
      if (kIsWeb) {
        result = await PredictionService.predictDiseaseWeb(_webImageBytes!);
      } else {
        result = await PredictionService.predictDisease(_imageFile!);
      }

      setState(() {
        _prediction = result['prediction'];
        _confidence = (result['confidence'] as num).toDouble();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prediction failed')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = _imageFile != null
        ? Image.file(_imageFile!, height: 200)
        : _webImageBytes != null
            ? Image.memory(_webImageBytes!, height: 200)
            : const Text('No image selected.');

    return Scaffold(
      body: Stack(
        children: [
          // 🔽 Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // 🔼 Foreground Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        imageWidget,
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.photo),
                          label: const Text('Select Image'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loading ? null : _predict,
                          icon: const Icon(Icons.search),
                          label: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Predict'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_prediction != null && _confidence != null)
                          Text(
                            'Prediction: $_prediction\nConfidence: ${(_confidence! * 100).toStringAsFixed(2)}%',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                      ],
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
}
