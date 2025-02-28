import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helthrepov1/controllers/dashctrl.dart';
import 'package:helthrepov1/controllers/viewrecctrl.dart';

class PatientListScreen extends StatelessWidget {
  final DashBoardController dsb = Get.find<DashBoardController>();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _filterPatients(List<dynamic> patients, String query) {
    return patients
        .where(
          (patient) =>
              patient["name"].toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Patient List",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            onPressed: () => Get.toNamed("/addnp"),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search patients...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => Get.forceAppUpdate(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: dsb.getPatients(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No patients available"));
                }

                final patients = _filterPatients(
                  snapshot.data!,
                  _searchController.text,
                );
                if (patients.isEmpty) {
                  return const Center(child: Text("No matching patients"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return GestureDetector(
                      onTap: () {
                        final vrcc = Get.find<ViewRecController>();
                        vrcc.id.value = patient['id'];
                        vrcc.name.value = patient['name'];
                        Get.toNamed("/viewrec");
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              patient["name"][0],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(
                            patient["name"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Age: ${patient["age"]}, Gender: ${patient["gender"]}",
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
