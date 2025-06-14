import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:booth_booking_app/database/db_helper.dart';

class AdminViewBookingsModal extends StatefulWidget {
  final Map<String, dynamic> user;

  const AdminViewBookingsModal({super.key, required this.user});

  @override
  State<AdminViewBookingsModal> createState() => _AdminViewBookingsModalState();
}

class _AdminViewBookingsModalState extends State<AdminViewBookingsModal> {
  late Future<List<Map<String, dynamic>>> _bookingFuture;

  @override
  void initState() {
    super.initState();
    _bookingFuture = DatabaseHelper.instance.getUserBookings(widget.user['id']);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.48,
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
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _bookingFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final bookings = snapshot.data!;
              if (bookings.isEmpty) {
                // return const Center(child: Text('No bookings found.'));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Center(
                        // title
                        child: Text(
                          "${widget.user['fullName'] ?? 'Unknown'} Bookings",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Center(child: Text('No bookings found.'))),
                  ],
                );
              }

              // if has data, display here
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Center(
                      // title
                      child: Text(
                        "${widget.user['fullName'] ?? 'Unknown'} Bookings",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // booking details
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 50),
                      itemCount: bookings.length,
                      itemBuilder: (_, index) {
                        final booking = bookings[index];
                        final dateTime = DateTime.parse(
                          booking['bookDateTime'],
                        );

                        // decode additional items
                        Map<String, dynamic> additionalItems = {};
                        if (booking['additionalItems'] != null &&
                            booking['additionalItems'].toString().isNotEmpty) {
                          try {
                            additionalItems = json.decode(
                              booking['additionalItems'],
                            );
                          } catch (e) {
                            additionalItems = {};
                          }
                        }

                        // return additional items that has atleast 1 qty
                        final filteredItems =
                            additionalItems.entries.where((e) {
                              final value = e.value;
                              return value['qty'] > 0;
                            }).toList();

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // package name
                              Text(
                                '${index + 1}. ${booking['packageName']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // booking date, time, price
                              Text(
                                'Booking Date: ${DateFormat('d MMMM yyyy').format(dateTime)}',
                              ),
                              Text(
                                'Booking Time: ${DateFormat('h:mm a').format(dateTime)}',
                              ),
                              Text(
                                'Package Price: RM ${booking['packagePrice'].toStringAsFixed(2)}',
                              ),

                              // additional items
                              if (filteredItems.isNotEmpty) ...[
                                const SizedBox(height: 15),
                                const Text(
                                  'Additional Items:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...filteredItems.map((item) {
                                  final name = item.key;
                                  final data = item.value;
                                  return Text(
                                    'x${data['qty']} $name (RM ${data['total'].toStringAsFixed(2)})',
                                  );
                                }),
                              ],
                              const SizedBox(height: 15),

                              // total price
                              const Text(
                                'Total Price:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'RM ${booking['totalPrice'].toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.black),
                              ),

                              // last booking no divider
                              if (index != bookings.length - 1)
                                const Divider(height: 35, thickness: 1),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
