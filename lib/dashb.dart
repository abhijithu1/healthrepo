import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        },
      },
      {
        'icon': Icons.folder_open,
        'title': 'View Records',
        'onTap': () {
          // Navigate to records screen
        },
      },
      {
        'icon': Icons.monitor_heart,
        'title': 'Chronic Condition Monitoring',
        'onTap': () {
          // Navigate to monitoring screen
          Get.toNamed("/chronic");
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

  // 4. Recent Patients
  Widget _buildRecentPatients() {
    // Sample patient data
    final List<Map<String, dynamic>> recentPatients = [
      {
        'name': 'John Doe',
        'lastVisit': '12 Oct 2023',
        'condition': 'Diabetes',
        'conditionColor': Colors.green,
        'initials': 'JD',
      },
      {
        'name': 'Emily Smith',
        'lastVisit': '10 Oct 2023',
        'condition': 'Hypertension',
        'conditionColor': Colors.blue,
        'initials': 'ES',
      },
      {
        'name': 'Michael Brown',
        'lastVisit': '5 Oct 2023',
        'condition': 'Asthma',
        'conditionColor': Colors.purple,
        'initials': 'MB',
      },
      {
        'name': 'Sarah Johnson',
        'lastVisit': '2 Oct 2023',
        'condition': 'Arthritis',
        'conditionColor': Colors.orange,
        'initials': 'SJ',
      },
    ];

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
            child: ListView.builder(
              itemCount: recentPatients.length,
              itemBuilder: (context, index) {
                final patient = recentPatients[index];
                return GestureDetector(
                  onTap: () => Get.toNamed("/pp"),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: patient['conditionColor'].withOpacity(0.2),
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
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, size: 18),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem(
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
