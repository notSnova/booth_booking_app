import 'package:flutter/material.dart';
import 'package:booth_booking_app/database/db_helper.dart';

class AdminEditUserModal extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onUserUpdated;

  const AdminEditUserModal({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<AdminEditUserModal> createState() => _AdminEditUserModalState();
}

class _AdminEditUserModalState extends State<AdminEditUserModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController usernameController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  String? _usernameError;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user['username']);
    nameController = TextEditingController(text: widget.user['fullName']);
    emailController = TextEditingController(text: widget.user['email']);
    phoneController = TextEditingController(text: widget.user['phone']);
    passwordController = TextEditingController(
      text: widget.user['password'] ?? '',
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  OutlineInputBorder _blackBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    );
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final newUsername = usernameController.text.trim();

      setState(() => _usernameError = null);

      // Only check for uniqueness if the username has changed
      if (newUsername != widget.user['username']) {
        final exists = await DatabaseHelper.instance.usernameExists(
          newUsername,
        );
        if (exists) {
          setState(() => _usernameError = 'Username already taken');
          return;
        }
      }

      final updatedUser = {
        'id': widget.user['id'],
        'username': newUsername,
        'fullName': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text.trim(),
      };

      await DatabaseHelper.instance.updateUser(updatedUser);
      widget.onUserUpdated();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      // success message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.user['fullName']} profile has been updated.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Edit User Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // username
                            TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: _blackBorder(),
                                errorText: _usernameError,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // full name
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: _blackBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Full name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // email
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: _blackBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // phone
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: _blackBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (!RegExp(r'^\d+$').hasMatch(value)) {
                                  return 'Phone number must be numeric only';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // password
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: _blackBorder(),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 6) {
                                  return 'Minimum 6 characters required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            // save button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
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
