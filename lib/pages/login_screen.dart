import 'package:booth_booking_app/database/db_helper.dart';
import 'package:booth_booking_app/pages/register_screen.dart';
import 'package:booth_booking_app/pages/user/user_main_screen.dart';
import 'package:booth_booking_app/pages/booth_packages_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'dart:developer';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String? _usernameError;
  String? _passwordError;

  // dispose controller to free resource
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // login check
  void _tryLogin() async {
    setState(() {
      _usernameError = null;
      _passwordError = null;
    });

    if (_formKey.currentState!.validate()) {
      final username = usernameController.text.trim();
      final password = passwordController.text;

      // username check
      final user = await DatabaseHelper.instance.getUserByUsername(username);
      if (user == null) {
        setState(() {
          _usernameError = "User not found";
        });
        return;
      }

      // password check
      if (user['password'] == password) {
        log("Login successful for: $username");

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Login successful!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 3),
          ),
        );

        // navigate based on role
        if (user['role'] == 'admin') {
          // Navigator.pushReplacementNamed(context, '/adminDashboard');
          log('admin logged in');
        } else {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => UserMainScreen(user: user)),
          );
        }
      } else {
        setState(() {
          _passwordError = "Incorrect password";
        });
      }
    } else {
      log("Validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BoothPackagesScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // logo
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Image.asset('assets/expo-logo.png', height: 80),
                    ),
                    const SizedBox(height: 20),

                    // username field
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        errorText: _usernameError,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // password field
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: _passwordError,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // login button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _tryLogin,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // register button
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Register here',
                            style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                          ),
                        ],
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
}
