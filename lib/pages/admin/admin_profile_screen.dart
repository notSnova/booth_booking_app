import 'package:booth_booking_app/database/db_helper.dart';
import 'package:booth_booking_app/pages/login_screen.dart';
import 'package:flutter/material.dart';

class AdminProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const AdminProfileScreen({super.key, required this.user});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  late TextEditingController usernameController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  String? _usernameError; // custom error message for username

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
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    //get user data by id
    final adminData = await DatabaseHelper.instance.getUserById(
      widget.user['id'],
    );

    if (adminData != null) {
      usernameController.text = adminData['username'] ?? '';
      nameController.text = adminData['fullName'] ?? '';
      emailController.text = adminData['email'] ?? '';
      phoneController.text = adminData['phone'] ?? '';
      passwordController.text = adminData['password'] ?? '';
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

  // custom border color
  OutlineInputBorder _blackBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    );
  }

  // edit mode
  void _toggleEditMode() async {
    if (isEditing) {
      if (_formKey.currentState!.validate()) {
        final newUsername = usernameController.text.trim();

        // reset username error
        setState(() {
          _usernameError = null;
        });

        // check if admin change their username
        if (newUsername != widget.user['username']) {
          final exists = await DatabaseHelper.instance.usernameExists(
            newUsername,
          );
          if (exists) {
            // show error message
            setState(() {
              _usernameError = 'Username already taken';
            });
            return;
          }
        }

        // if valid, prepare updated admin data
        final updatedAdmin = {
          'id': widget.user['id'],
          'username': newUsername,
          'fullName': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'password': passwordController.text.trim(),
        };

        // update the data
        await DatabaseHelper.instance.updateUser(updatedAdmin);

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
        title: const Text('Admin Profile'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Image.asset(
                    'assets/expo-logo.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 30),

                  // username
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      disabledBorder: _blackBorder(),
                      focusedBorder: _blackBorder(),
                      errorText: _usernameError,
                    ),
                    enabled: isEditing,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Username is required'
                                : null,
                  ),
                  const SizedBox(height: 16),

                  // fullname
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      disabledBorder: _blackBorder(),
                      focusedBorder: _blackBorder(),
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
                      border: OutlineInputBorder(),
                      disabledBorder: _blackBorder(),
                      focusedBorder: _blackBorder(),
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
                      border: OutlineInputBorder(),
                      disabledBorder: _blackBorder(),
                      focusedBorder: _blackBorder(),
                    ),
                    enabled: isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      if (!RegExp(r'^\d+$').hasMatch(value)) {
                        return 'Phone must be numeric';
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
                      border: OutlineInputBorder(),
                      disabledBorder: _blackBorder(),
                      focusedBorder: _blackBorder(),
                    ),
                    enabled: isEditing,
                    obscureText: true,
                    validator: (value) {
                      if (!isEditing) return null;
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) return 'Minimum 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // save or edit button
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

                  // logout button
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
