import 'dart:developer';

import 'package:booth_booking_app/widgets/admin_edit_user_modal.dart';
import 'package:booth_booking_app/widgets/admin_view_bookings_modal.dart';
import 'package:flutter/material.dart';
import 'package:booth_booking_app/database/db_helper.dart';

class AdminRegisteredUsersScreen extends StatefulWidget {
  const AdminRegisteredUsersScreen({super.key});

  @override
  State<AdminRegisteredUsersScreen> createState() =>
      _AdminRegisteredUsersScreenState();
}

class _AdminRegisteredUsersScreenState
    extends State<AdminRegisteredUsersScreen> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    // get users data
    final allUsers = await DatabaseHelper.instance.getUsers();

    // filter out admin
    final filteredUsers =
        allUsers.where((user) => user['role'] != 'admin').toList();

    setState(() {
      users = filteredUsers;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Users'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 16, 30, 100),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'assets/expo-logo.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                if (isLoading)
                  const CircularProgressIndicator()
                else if (users.isEmpty)
                  const Text(
                    'No registered users found.',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 5, 5, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      user['fullName'] ?? 'No Name',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  // edit button
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder:
                                            (_) => AdminEditUserModal(
                                              user: user,
                                              onUserUpdated: _loadUsers,
                                            ),
                                      );
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              title: Center(
                                                child: Text(
                                                  'Delete user ${user['username']}?',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              content: Text(
                                                'All related bookings will also be permanently deleted.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                              actionsPadding:
                                                  const EdgeInsets.only(
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
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );

                                      // if user press delete, delete the data
                                      if (confirm == true) {
                                        await DatabaseHelper.instance
                                            .deleteUser(user['id']);

                                        // check for user existence
                                        final deletedUser = await DatabaseHelper
                                            .instance
                                            .getUserById(user['id']);
                                        final bookings = await DatabaseHelper
                                            .instance
                                            .getUserBookings(user['id']);

                                        log(
                                          'User check after deletion: ${deletedUser == null ? 'User deleted' : 'User still exists'}',
                                        );
                                        log(
                                          'Related bookings count: ${bookings.length}',
                                        );

                                        _loadUsers(); // refresh list

                                        ScaffoldMessenger.of(
                                          // ignore: use_build_context_synchronously
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'User ${user['username']} has been deleted.',
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // user details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(user['email']),
                                        Text(user['phone']),
                                      ],
                                    ),
                                  ),

                                  // view bookings button
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: TextButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder:
                                              (_) => AdminViewBookingsModal(
                                                user: user,
                                              ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        'View Bookings',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
