import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helthrepov1/controllers/dashctrl.dart';
import 'package:helthrepov1/controllers/viewrecctrl.dart';

class ViewRecordsScreen extends StatelessWidget {
  const ViewRecordsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vrcc = Get.find<ViewRecController>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "View Records",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A73E8), // Google Blue
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Selection Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search patients by name or ABHA ID",
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 16,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      // Clear search functionality will be implemented later
                    },
                  ),
                ),
                onTap: () {
                  Get.to(SearchScreen())!.then((_) {
                    vrcc.refreshFuture();
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // Selected Patient Info (Placeholder - Would be populated from backend)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue.shade100,
                    child: const Text("J"), // Placeholder initial
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          vrcc.name.value, // Placeholder name
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Text(
                        "ABHA ID: ABHA12345", // Placeholder ABHA ID
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Records Title
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Patient Records",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Records List (Placeholder - Would be populated from backend)
            Expanded(
              child: Obx(() {
                return FutureBuilder(
                  key: ValueKey(vrcc.refreshTrigger.value),
                  future: vrcc.getRecords(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No patients found.'));
                    } else {
                      final recordlist = snapshot.data!;
                      return ListView.builder(
                        itemCount: recordlist.length,
                        itemBuilder: (BuildContext context, index) {
                          final rr = recordlist[index];
                          return _buildRecordCard(
                            type: rr['record_type'],
                            date: rr['date'],
                            summary: rr['summary'],
                            hasAttachments: true,
                            context: context,
                          );
                        },
                      );
                    }
                  },
                );
              }),
              // child: ListView(
              //   children: [
              //     _buildRecordCard(
              //       type: "Lab Report",
              //       date: "15 Oct 2023",
              //       summary: "Blood Sugar Level: 250 mg/dL",
              //       hasAttachments: true,
              //       context: context,
              //     ),
              //     _buildRecordCard(
              //       type: "Diagnosis",
              //       date: "20 Sep 2023",
              //       summary: "Type 2 Diabetes",
              //       hasAttachments: false,
              //       context: context,
              //     ),
              //     _buildRecordCard(
              //       type: "Treatment",
              //       date: "10 Oct 2023",
              //       summary: "Physiotherapy for lower back pain",
              //       hasAttachments: true,
              //       context: context,
              //     ),
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard({
    required String type,
    required String date,
    required String summary,
    required bool hasAttachments,
    required BuildContext context,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(summary, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _showRecordDetailsModal(context);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.visibility, size: 16),
                      SizedBox(width: 4),
                      Text("View Details"),
                    ],
                  ),
                ),
                if (hasAttachments)
                  TextButton(
                    onPressed: () {
                      // Download functionality will be implemented later
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Download functionality will be implemented later",
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.download, size: 16),
                        SizedBox(width: 4),
                        Text("Download"),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRecordDetailsModal(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Lab Report", // Placeholder type
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "15 Oct 2023", // Placeholder date
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Detailed Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sample detailed information - would be populated from backend
                          _buildDetailItem("Blood Sugar", "250 mg/dL"),
                          _buildDetailItem("Cholesterol", "180 mg/dL"),
                          _buildDetailItem("Blood Pressure", "120/80 mmHg"),

                          const SizedBox(height: 16),
                          const Text(
                            "Attachments",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Sample attachment - would be populated from backend
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.insert_drive_file),
                            title: const Text("lab_report.pdf"),
                            trailing: IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () {
                                // Download functionality will be implemented later
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Download functionality will be implemented later",
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: const Color(0xFF1A73E8), // Google Blue
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Close",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dsb = Get.find<DashBoardController>();
    // final res = dsb.getPatients();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Search Patients",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A73E8), // Google Blue
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search patients by name or ABHA ID",
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 16,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      // Clear search functionality will be implemented later
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Search Results
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: dsb.getPatients(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No patients found.'));
                  } else {
                    final patientlist = snapshot.data!;
                    return ListView.builder(
                      itemCount: patientlist.length,
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                          onTap: () async {
                            final vrcc = Get.find<ViewRecController>();
                            vrcc.name.value = patientlist[index]['name'];
                            vrcc.id.value = patientlist[index]['id'];

                            Get.back(result: true);
                          },
                          title: Text(patientlist[index]['name']),
                        );
                      },
                    );
                  }
                },
              ),
              // child: ListView.builder(
              //   itemCount: searchResults.length,
              //   itemBuilder: (context, index) {
              //     final result = searchResults[index];
              //     return ListTile(
              //       title: Text(result['name']),
              //       // subtitle: Text(result['summary']),
              //       onTap: () {
              //         // Handle tap on search result
              //       },
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mock data for search results
