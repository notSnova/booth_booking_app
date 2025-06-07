import 'package:booth_booking_app/database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserBookingHistoryScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserBookingHistoryScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getUserBookings(user['id']),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final bookings = snapshot.data!;
        if (bookings.isEmpty) {
          return const Center(child: Text('No booking history.'));
        }

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            final dateTime = DateTime.parse(booking['bookDateTime']);
            return ListTile(
              title: Text(booking['packageName']),
              subtitle: Text(
                'Date: ${DateFormat('d MMM yyyy, h:mm a').format(dateTime)}\n'
                'Price: ${booking['packagePrice']}',
              ),
              isThreeLine: true,
            );
          },
        );
      },
    );
  }
}
