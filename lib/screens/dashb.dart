import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helthrepov1/controllers/dashctrl.dart';
import 'package:helthrepov1/controllers/profilectrl.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dash = Get.find<DashBoardController>();
    final patientlist = dash.getPatients();
    return MaterialApp(
      title: 'Doctor Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1A73E8),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Roboto',
      ),
      home: const DoctorDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final String doctorName = "Sarah Johnson";
  final int notificationCount = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildRecentPatients(),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Header section
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Welcome, Dr. $doctorName!',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF202124),
          ),
        ),
        Row(
          children: [
            // Notification Bell
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 28),
                  onPressed: () {
                    _showNotificationsDropdown(context);
                  },
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            // Profile Icon
            InkWell(
              onTap: () {
                _showProfileDropdown(context);
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Text(
                  'SJ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. Search Bar
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF757575)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for patients...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Color(0xFF757575)),
            onPressed: () {
              // Voice search functionality
            },
          ),
        ],
      ),
    );
  }

  // 3. Quick Actions
  Widget _buildQuickActions() {
    final List<Map<String, dynamic>> quickActions = [
      {
        'icon': Icons.person_add,
        'title': 'Add New Patient',
        'onTap': () {
          // Navigate to add patient screen
          Get.toNamed("/addnp");
        },
      },
      {
        'icon': Icons.people,
        'title': 'View Patients',
        'onTap': () {
          Get.toNamed("/viewpat");
          // Navigate to records screen
        },
      },
      {
        'icon': Icons.message_rounded,
        'title': 'AI chat',
        'onTap': () {
          // Navigate to monitoring screen
          Get.toNamed("/chat");
        },
      },
      {
        'icon': Icons.notifications_active,
        'title': 'Alerts',
        'onTap': () {
          // Navigate to alerts screen
          Get.toNamed("/alert");
        },
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF202124),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: quickActions.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: quickActions[index]['onTap'],
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        quickActions[index]['icon'],
                        color: Theme.of(context).primaryColor,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        quickActions[index]['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF202124),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Generate a random last visit date
  String _getRandomLastVisit() {
    final random = Random();
    final day = random.nextInt(28) + 1; // Random day between 1 and 28
    final month = random.nextInt(12) + 1; // Random month between 1 and 12
    final year = 2023; // Fixed year
    return '$day/$month/$year';
  }

  // Generate a random condition
  String _getRandomCondition() {
    final conditions = ['Diabetes', 'Hypertension', 'Asthma', 'Arthritis'];
    final random = Random();
    return conditions[random.nextInt(conditions.length)];
  }

  // Generate a random color
  Color _getRandomColor() {
    final colors = [Colors.green, Colors.blue, Colors.purple, Colors.orange];
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }

  // Extract initials from the name
  String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}';
    } else if (names.isNotEmpty) {
      return names[0][0];
    }
    return '';
  }

  // 4. Recent Patients
  Widget _buildRecentPatients() {
    // Retrieve the patient list from the backend
    final dash = Get.find<DashBoardController>();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Patients',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202124),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed("/viewpat");
                  // Navigate to all patients screen
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: dash.getPatients(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Image.asset(
                      'assets/loadgif.gif', // Ensure you have a loading GIF in assets
                      width: 100,
                      height: 100,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Image.asset(
                      'assets/loadgif.gif', // Ensure you have a loading GIF in assets
                      width: 100,
                      height: 100,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Image.asset(
                      'assets/loadgif.gif', // Ensure you have a loading GIF in assets
                      width: 100,
                      height: 100,
                    ),
                  );
                } else {
                  final patientlist = snapshot.data!;
                  final List<Map<String, dynamic>> recentPatients =
                      patientlist.map((patient) {
                        return {
                          'name': patient['name'],
                          'id': patient['id'],
                          'lastVisit': _getRandomLastVisit(),
                          'condition': _getRandomCondition(),
                          'conditionColor': _getRandomColor(),
                          'initials': _getInitials(patient['name']),
                        };
                      }).toList();

                  return ListView.builder(
                    itemCount: recentPatients.length,
                    itemBuilder: (context, index) {
                      final patient = recentPatients[index];
                      return GestureDetector(
                        onTap: () {
                          final pp = Get.find<ProfileController>();
                          pp.id.value = recentPatients[index]['id'];
                          pp.name.value = patient['name'];
                          Get.toNamed("/pp");
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey.shade200,
                                  child: Text(
                                    patient['initials'],
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patient['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF202124),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Last Visit: ${patient['lastVisit']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: patient['conditionColor']
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    patient['condition'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: patient['conditionColor'],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Dropdown for profile icon
  void _showProfileDropdown(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 0, 0),
      items: [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 18),
              SizedBox(width: 8),
              Text('View Profile'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            Get.toNamed("/setbase");
          },
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, size: 18),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () async {
            final box = GetStorage();
            await box.remove("token");
            Get.offAllNamed("/login");
          },
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 18),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'profile') {
        // Navigate to profile
      } else if (value == 'settings') {
        // Navigate to settings
      } else if (value == 'logout') {
        // Perform logout
      }
    });
  }

  // Dropdown for notifications
  void _showNotificationsDropdown(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {'message': 'Abnormal BP for John Doe', 'time': '2 hours ago'},
      {'message': 'Lab results ready for Emily Smith', 'time': '3 hours ago'},
      {
        'message': 'Medication reminder for Michael Brown',
        'time': '5 hours ago',
      },
    ];

    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 0, 0),
      items: [
        ...notifications.map(
          (notification) => PopupMenuItem(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['message']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['time']!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          child: Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to all alerts screen
              },
              child: Text(
                'View All Alerts',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
