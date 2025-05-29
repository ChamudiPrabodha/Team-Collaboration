import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';




class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  Future<void> sendOTP(String phoneNumber, Function(String) onCodeSent) async {
    if (kIsWeb) {
      final confirmationResult = await _auth.signInWithPhoneNumber(
  phoneNumber,
  RecaptchaVerifier(
  auth: FirebaseAuthPlatform.instance,
  container: 'recaptcha-container',
  size: RecaptchaVerifierSize.normal,
  theme: RecaptchaVerifierTheme.light,
),

);

      _verificationId = confirmationResult.verificationId;
      onCodeSent(_verificationId!);
    } else {
      // Native mobile flow
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-sign-in on Android devices with instant verification
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('Verification failed: $e');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    }
  }

  Future<bool> verifyOTP(String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      debugPrint("OTP Verification failed: $e");
      return false;
    }
  }
}
