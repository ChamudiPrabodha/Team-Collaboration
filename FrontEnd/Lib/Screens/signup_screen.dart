import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import '../services/user_service.dart'; // Adjust path based on your structure

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '', userName = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  bool _isLoading = false;

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

        User? user = userCredential.user;
        if (user != null) {
          await user.updateDisplayName(userName);
          await user.reload();

          // Prepare user data
          Map<String, dynamic> userData = {
            'email': email.trim().toLowerCase(),
            'password': password,
            'name': userName,
            'phone': '',
            'region': '',
            'address': '',
          };

          bool backendSuccess = await _userService.signupUser(userData);

          if (backendSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signup successful! Please login.')),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signup succeeded in Firebase but failed on backend.')),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'email-already-in-use') {
          message = 'Email already in use.';
        } else if (e.code == 'weak-password') {
          message = 'Password too weak.';
        } else {
          message = 'Signup failed. ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/a.jpg', // Ensure this image exists in pubspec.yaml
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    const Text(
                      "Create Your Account",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Username",
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                      onChanged: (value) => userName = value,
                      validator: (value) => value!.isEmpty ? "Enter username" : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Email",
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                      onChanged: (value) => email = value,
                      validator: (value) => value!.isEmpty ? "Enter email" : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                      onChanged: (value) => password = value,
                      validator: (value) => value!.length < 6 ? "Min 6 characters" : null,
                    ),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 18, 21, 18),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 50),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            onPressed: _registerUser,
                            child: const Text("Signup"),
                          ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
