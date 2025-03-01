import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helthrepov1/controllers/profilectrl.dart';

class AddNewRecordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final profctrl = Get.find<ProfileController>();

  void _saveRecord(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Show loading animation
      Get.dialog(
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/loading.gif', // Ensure you have a loading GIF in assets
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 10),
              const Text("Saving record...", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      await profctrl.postrecord();
      Get.back(); // Close the loading dialog
      Get.back(); // Navigate back after success

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Record'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: profctrl.nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a name'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: profctrl.urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a URL'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: profctrl.recordTypeController,
                decoration: const InputDecoration(
                  labelText: 'Record Type',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a record type'
                            : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () => _saveRecord(context),
                    child: const Text('Save', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
