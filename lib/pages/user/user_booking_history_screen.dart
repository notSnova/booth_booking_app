import 'package:booth_booking_app/database/db_helper.dart';
import 'package:booth_booking_app/pages/user/user_edit_booking_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
// import 'dart:developer';

class UserBookingHistoryScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserBookingHistoryScreen({super.key, required this.user});

  @override
  State<UserBookingHistoryScreen> createState() =>
      _UserBookingHistoryScreenState();
}

class _UserBookingHistoryScreenState extends State<UserBookingHistoryScreen> {
  late Future<List<Map<String, dynamic>>> _bookingFuture;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    _bookingFuture = DatabaseHelper.instance.getUserBookings(widget.user['id']);
  }

  void _refreshBookings() {
    setState(() {
      _loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Booking History",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookingFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final bookings = snapshot.data!;
          if (bookings.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Image.asset('assets/expo-logo.png', height: 80),
                  ),
                  const SizedBox(height: 30),
                  const Center(child: Text('No booking history.')),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
            itemCount: bookings.length + 1, // +1 for logo at top
            itemBuilder: (context, index) {
              // show logo at top
              if (index == 0) {
                return Column(
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: Image.asset('assets/expo-logo.png', height: 80),
                    ),
                    const SizedBox(height: 30),
                  ],
                );
              }

              final booking = bookings[index - 1];
              final dateTime = DateTime.parse(booking['bookDateTime']);

              // parse and filter additional items
              Map<String, dynamic> additionalItems = {};
              if (booking['additionalItems'] != null &&
                  booking['additionalItems'].toString().isNotEmpty) {
                try {
                  additionalItems = json.decode(booking['additionalItems']);
                } catch (e) {
                  additionalItems = {}; // fallback if parse fails
                }
              }

              // filter items with quantities more than 0
              final filteredItems =
                  additionalItems.entries.where((e) {
                    final value = e.value;
                    return value['qty'] > 0;
                  }).toList();

              return Card(
                margin: const EdgeInsets.only(bottom: 25, left: 20, right: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 5,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // header and edit/delete button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            booking['packageName'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Row(
                            // edit button
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  final updated = await showModalBottomSheet<
                                    bool
                                  >(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.7,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25),
                                          ),
                                        ),
                                        child: UserEditBookingModal(
                                          booking: booking,
                                        ),
                                      );
                                    },
                                  );

                                  if (updated == true) {
                                    _refreshBookings();
                                  }
                                },
                              ),

                              // delete button
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade400,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  // show dialog box
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          title: Center(
                                            child: Text(
                                              'Delete ${booking['packageName']}?',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          content: Text(
                                            'This booking will be permanently deleted and cannot be recovered.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          actionsPadding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red.shade400,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );

                                  // if user press delete, delete the data
                                  if (confirm == true) {
                                    await DatabaseHelper.instance.deleteBooking(
                                      booking['bookid'],
                                    );

                                    _refreshBookings(); // refresh list

                                    ScaffoldMessenger.of(
                                      // ignore: use_build_context_synchronously
                                      context,
                                    ).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${booking['packageName']} has been removed from booking history.',
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
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      // booking details
                      Text(
                        'Booking Date: ${DateFormat('d MMMM yyyy').format(dateTime)}',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Booking Time: ${DateFormat('h:mm a').format(dateTime)}',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Package Price: RM ${booking['packagePrice'].toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.black),
                      ),
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
                          final itemName = item.key;
                          final itemData = item.value;
                          final qty = itemData['qty'];
                          final totalItem = itemData['total'];
                          return Text(
                            'x$qty $itemName (RM ${totalItem.toStringAsFixed(2)})',
                          );
                        }),
                      ],
                      const SizedBox(height: 15),
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
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
