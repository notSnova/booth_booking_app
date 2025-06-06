// import 'package:booth_booking_app/database/db_helper.dart';
import 'package:flutter/material.dart';
import 'pages/welcome_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final dbHelper = DatabaseHelper.instance;
  // await dbHelper.deleteDatabaseFile();
  // await dbHelper.database;

  runApp(const ExpoApp());
}

class ExpoApp extends StatelessWidget {
  const ExpoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exhibition Booth Booking',
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
        ).copyWith(secondary: Colors.black),
        scaffoldBackgroundColor: const Color(0xFFDEDEDE),
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
