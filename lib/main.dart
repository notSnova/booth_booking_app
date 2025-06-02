import 'package:flutter/material.dart';
import 'pages/home_screen.dart';

void main() {
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
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
