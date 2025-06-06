import 'package:booth_booking_app/pages/user/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:booth_booking_app/pages/user/user_booth_packages_screen.dart';
import 'package:booth_booking_app/widgets/user_bottom_nav.dart';

class UserMainScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserMainScreen({super.key, required this.user});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    // Use switch-case to control page rendering
    switch (_selectedIndex) {
      case 0:
        bodyContent = UserBoothPackagesScreen(user: widget.user);
        break;
      case 1:
        bodyContent = UserProfileScreen(user: widget.user);
        break;
      default:
        bodyContent = const Center(
          child: Text('Unknown Page', style: TextStyle(fontSize: 20)),
        );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: bodyContent),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: UserBottomNav(
              currentIndex: _selectedIndex,
              onTabTapped: _onTabSelected,
            ),
          ),
        ],
      ),
    );
  }
}
