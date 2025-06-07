import 'dart:convert';
import 'dart:developer';

import 'package:booth_booking_app/database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booth_package.dart';

class UserBoothDetailsModal extends StatefulWidget {
  final BoothPackage package;
  final Map<String, dynamic> user;

  const UserBoothDetailsModal({
    super.key,
    required this.package,
    required this.user,
  });

  @override
  State<UserBoothDetailsModal> createState() => _UserBoothDetailsModalState();
}

class _UserBoothDetailsModalState extends State<UserBoothDetailsModal> {
  late Map<String, int> itemQuantities;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool dateError = false;
  bool timeError = false;

  @override
  void initState() {
    super.initState();
    // initialize the additional item quantities map only once
    itemQuantities = {for (var item in widget.package.additionalItems) item: 0};
  }

  // date and time picker setup
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // cancel button text
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateError = false;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
              secondary: Colors.black,
              onSecondary: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        timeError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final package = widget.package;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: screenHeight * 0.75, // card height
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                package.imagePath,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),

            // scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                    // book date and time picker
                    const Text(
                      "Select Booking Date & Time:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // select date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: _pickDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    dateError
                                        ? Colors.red
                                        : Colors.grey.shade400,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              selectedDate != null
                                  ? DateFormat('d MMMM y').format(selectedDate!)
                                  : "Tap to choose date",
                              style: TextStyle(
                                fontSize: 15,
                                color: dateError ? Colors.red : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        if (dateError)
                          const Padding(
                            padding: EdgeInsets.only(top: 5, left: 4),
                            child: Text(
                              "Please select a date",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // select time
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: _pickTime,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    timeError
                                        ? Colors.red
                                        : Colors.grey.shade400,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              selectedTime != null
                                  ? selectedTime!.format(context)
                                  : "Tap to choose time",
                              style: TextStyle(
                                fontSize: 15,
                                color: timeError ? Colors.red : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        if (timeError)
                          const Padding(
                            padding: EdgeInsets.only(top: 5, left: 4),
                            child: Text(
                              "Please select a time",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // additional items
                    if (package.additionalItems.isNotEmpty) ...[
                      const Text(
                        "Optional Extras:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Column(
                        children:
                            package.additionalItems.map((item) {
                              final quantity = itemQuantities[item] ?? 0;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (itemQuantities[item]! > 0) {
                                                itemQuantities[item] =
                                                    itemQuantities[item]! - 1;
                                              }
                                            });
                                          },
                                        ),
                                        Text(
                                          '$quantity',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              itemQuantities[item] =
                                                  itemQuantities[item]! + 1;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // book package button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // date and time validation check
                          setState(() {
                            dateError = selectedDate == null;
                            timeError = selectedTime == null;
                          });

                          if (dateError || timeError) {
                            return;
                          }

                          // combine date and time
                          final combinedDateTime = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );
                          final formattedDateTime =
                              combinedDateTime.toIso8601String();

                          // insert data to table
                          final bookingData = {
                            'userid': widget.user['id'],
                            'packageName': widget.package.name,
                            'packagePrice': widget.package.price.toString(),
                            'bookDateTime': formattedDateTime,
                            'additionalItems': jsonEncode(itemQuantities),
                          };

                          await DatabaseHelper.instance.insertBooking(
                            bookingData,
                          );
                          log("Your Booking Data: $bookingData");

                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Package booking confirmed!",
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
