import 'package:booth_booking_app/database/db_helper.dart';
import 'package:booth_booking_app/pages/login_screen.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late TextEditingController usernameController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  bool isEditing = false;
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    usernameController = TextEditingController();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
    _loadUserData();
  }

  // get user data by username
  Future<void> _loadUserData() async {
    final userData = await DatabaseHelper.instance.getUserById(
      widget.user['id'],
    );

    if (userData != null) {
      usernameController.text = userData['username'] ?? '';
      nameController.text = userData['fullName'] ?? '';
      emailController.text = userData['email'] ?? '';
      phoneController.text = userData['phone'] ?? '';
      passwordController.text = userData['password'] ?? '';
    }

    setState(() {
      isLoading = false;
    });
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

  // border color
  OutlineInputBorder _blackBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    );
  }

  OutlineInputBorder _errorBorder() {
    return const OutlineInputBorder(borderSide: BorderSide(color: Colors.red));
  }

  // edit mode
  void _toggleEditMode() async {
    if (isEditing) {
      if (_formKey.currentState!.validate()) {
        // prepare updated user data
        final updatedUser = {
          'id': widget.user['id'],
          'username': usernameController.text.trim(),
          'fullName': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'password': passwordController.text.trim(),
        };

        // call update method
        await DatabaseHelper.instance.updateUser(updatedUser);

        setState(() => isEditing = false);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Profile updated successfully.",
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
      }
    } else {
      setState(() => isEditing = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/expo-logo.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),

                  // username
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: _blackBorder(),
                      disabledBorder: _blackBorder(),
                      focusedBorder: _blackBorder(),
                      errorBorder: _errorBorder(),
                    ),
                    enabled: isEditing,
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
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: _blackBorder(),
                      disabledBorder: _blackBorder(),
                      focusedBorder: _blackBorder(),
                      errorBorder: _errorBorder(),
                    ),
                    enabled: isEditing,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Full name is required'
                                : null,
                  ),
                  const SizedBox(height: 16),

                  // email
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: _blackBorder(),
                      disabledBorder: _blackBorder(),
                      focusedBorder: _blackBorder(),
                      errorBorder: _errorBorder(),
                    ),
                    enabled: isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: _blackBorder(),
                      disabledBorder: _blackBorder(),
                      focusedBorder: _blackBorder(),
                      errorBorder: _errorBorder(),
                    ),
                    enabled: isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      if (!RegExp(r'^\d+$').hasMatch(value)) {
                        return 'Phone must be numeric only';
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
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: _blackBorder(),
                      disabledBorder: _blackBorder(),
                      focusedBorder: _blackBorder(),
                      errorBorder: _errorBorder(),
                    ),
                    enabled: isEditing,
                    obscureText: true,
                    validator: (value) {
                      if (!isEditing) return null;
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

                  // edit/save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _toggleEditMode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        isEditing ? 'Save Profile' : 'Edit Profile',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // logout
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "You've been logged out.",
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
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
