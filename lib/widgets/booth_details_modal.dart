import 'package:flutter/material.dart';
import '../models/booth_package.dart';
import '../pages/login_screen.dart';

class BoothDetailsModal extends StatelessWidget {
  final BoothPackage package;

  const BoothDetailsModal({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: MediaQuery.of(context).viewInsets, // for keyboard safe area
      child: Container(
        height: screenHeight * 0.75,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        package.imagePath,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // package name
                    Text(
                      package.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // price and size
                    Text("Price: RM ${package.price.toStringAsFixed(2)}"),
                    const SizedBox(height: 5),
                    Text("Size: ${package.size}"),
                    const SizedBox(height: 15),

                    // details
                    Text(package.details, style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 20),

                    // additional items
                    if (package.additionalItems.isNotEmpty) ...[
                      const Text(
                        "Optional Extras:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            package.additionalItems.keys.map((item) {
                              return Chip(
                                label: Text(item),
                                backgroundColor: Colors.grey.shade200,
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 30),
                    ],

                    // book now button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "You need to login first in order to book.",
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Book Package',
                          style: TextStyle(fontSize: 16),
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
    );
  }
}
