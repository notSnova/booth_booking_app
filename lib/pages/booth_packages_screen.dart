import 'package:booth_booking_app/widgets/booth_details_modal.dart';
import 'package:booth_booking_app/pages/welcome_screen.dart';
import 'package:flutter/material.dart';
import '../models/booth_package.dart';

class BoothPackagesScreen extends StatelessWidget {
  const BoothPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Available Booth Packages'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(height: 30),
              // logo
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Image.asset('assets/expo-logo.png', height: 80),
              ),
              // package card
              for (var package in boothPackages) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // package image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              package.imagePath,
                              width: double.infinity,
                              height: 280,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // package details
                          Text(
                            package.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(package.details),
                          const SizedBox(height: 30),

                          // view details button
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                // booth details modal
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder:
                                      (context) =>
                                          BoothDetailsModal(package: package),
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'View Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // space between cards
              ],
            ],
          ),
        ),
      ),
    );
  }
}
