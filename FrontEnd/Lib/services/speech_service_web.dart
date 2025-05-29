import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  bool isListening = false;

  Future<bool> initSpeech() async {
    return await _speech.initialize();
  }

  void startListening(Function(String) onResult) {
    _speech.listen(
      localeId: 'si-LK', // Sinhala. Use 'ta-IN' for Tamil.
      onResult: (result) => onResult(result.recognizedWords),
    );
    isListening = true;
  }

  void stopListening() {
    _speech.stop();
    isListening = false;
  }
}
