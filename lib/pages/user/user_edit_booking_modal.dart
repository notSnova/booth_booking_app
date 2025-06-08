import 'dart:convert';
import 'dart:developer';
import 'package:booth_booking_app/database/db_helper.dart';
import 'package:booth_booking_app/models/booth_package.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserEditBookingModal extends StatefulWidget {
  final Map<String, dynamic> booking;

  const UserEditBookingModal({super.key, required this.booking});

  @override
  State<UserEditBookingModal> createState() => _UserEditBookingModalState();
}

class _UserEditBookingModalState extends State<UserEditBookingModal> {
  late TextEditingController dateController;
  late TextEditingController timeController;

  late BoothPackage selectedPackage;

  Map<String, int> additionalItemsQuantities = {};

  @override
  void initState() {
    super.initState();

    final dateTime = DateTime.parse(widget.booking['bookDateTime']);
    dateController = TextEditingController(
      text: DateFormat('d MMMM y').format(dateTime),
    );
    timeController = TextEditingController(
      text: DateFormat('h:mm a').format(dateTime),
    );

    selectedPackage = boothPackages.firstWhere(
      (pkg) => pkg.name == widget.booking['packageName'],
      orElse: () => boothPackages.first,
    );

    additionalItemsQuantities = {};
    if (widget.booking['additionalItems'] != null) {
      try {
        final Map<String, dynamic> decoded = json.decode(
          widget.booking['additionalItems'],
        );
        for (var item in selectedPackage.additionalItems) {
          additionalItemsQuantities[item] = decoded[item] ?? 0;
        }
      } catch (_) {
        for (var item in selectedPackage.additionalItems) {
          additionalItemsQuantities[item] = 0;
        }
      }
    } else {
      for (var item in selectedPackage.additionalItems) {
        additionalItemsQuantities[item] = 0;
      }
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    // parse date from dateController
    final date = DateFormat('d MMMM y').parseStrict(dateController.text);

    // parse time from timeController
    final time = DateFormat('h:mm a').parseStrict(timeController.text);

    // combine date and time into a single DateTime
    final updatedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // formatted to update into database
    final updatedBooking = {
      ...widget.booking,
      'bookDateTime': updatedDateTime.toIso8601String(),
      'packageName': selectedPackage.name,
      'packagePrice': selectedPackage.price,
      'additionalItems': json.encode(additionalItemsQuantities),
    };

    // update to table
    await DatabaseHelper.instance.updateBooking(updatedBooking);

    // ignore: use_build_context_synchronously
    Navigator.pop(context, true);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Your booking has been updated!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 3),
      ),
    );
    log('$updatedBooking');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Edit Booking",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // package dropdown
            DropdownButtonFormField<BoothPackage>(
              value: selectedPackage,
              decoration: const InputDecoration(
                labelText: 'Select Package',
                border: OutlineInputBorder(),
              ),
              items:
                  boothPackages.map((pkg) {
                    return DropdownMenuItem<BoothPackage>(
                      value: pkg,
                      child: Text(
                        '${pkg.name} (RM ${pkg.price.toStringAsFixed(2)})',
                      ),
                    );
                  }).toList(),
              onChanged: (newPackage) {
                if (newPackage != null) {
                  setState(() {
                    selectedPackage = newPackage;
                    additionalItemsQuantities.clear();
                    for (var item in selectedPackage.additionalItems) {
                      additionalItemsQuantities[item] = 0;
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // date picker
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateFormat(
                    'd MMMM y',
                  ).parse(dateController.text),
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
                if (pickedDate != null) {
                  setState(() {
                    dateController.text = DateFormat(
                      'd MMMM y',
                    ).format(pickedDate);
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Pick Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // time picker
            GestureDetector(
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(
                    DateFormat('h:mm a').parse(timeController.text),
                  ),
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
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedTime != null) {
                  final now = DateTime.now();
                  final tempDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  setState(() {
                    timeController.text = DateFormat(
                      'h:mm a',
                    ).format(tempDateTime);
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Pick Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // additional items
            const Text(
              "Additional Items",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ...selectedPackage.additionalItems.map((item) {
              final qty = additionalItemsQuantities[item] ?? 0;
              return Row(
                children: [
                  Expanded(child: Text(item)),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        if (qty > 0) {
                          additionalItemsQuantities[item] = qty - 1;
                        }
                      });
                    },
                  ),
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      qty.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() {
                        additionalItemsQuantities[item] = qty + 1;
                      });
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 30),

            // save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 4,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
