import 'package:booth_booking_app/pages/admin/admin_registered_users_screen.dart';
import 'package:flutter/material.dart';
import 'package:booth_booking_app/pages/admin/admin_profile_screen.dart';
import 'package:booth_booking_app/widgets/admin_bottom_nav.dart';

class AdminMainScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const AdminMainScreen({super.key, required this.user});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    switch (_selectedIndex) {
      case 0:
        bodyContent = AdminRegisteredUsersScreen();
      case 2:
        bodyContent = AdminProfileScreen(user: widget.user);
        break;
      default:
        bodyContent = const Center(
          child: Text('Unknown Page', style: TextStyle(fontSize: 20)),
        );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: bodyContent),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AdminBottomNav(
              currentIndex: _selectedIndex,
              onTabTapped: _onTabSelected,
            ),
          ),
        ],
      ),
    );
  }
}
