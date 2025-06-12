import 'package:flutter/material.dart';

class AdminRegisteredUsersScreen extends StatelessWidget {
  const AdminRegisteredUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Users'),
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
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'assets/expo-logo.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                // Future: List of registered users will be displayed here
                const Text(
                  'User list will be shown here.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
