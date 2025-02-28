import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helthrepov1/controllers/profilectrl.dart';

class AddNewRecordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final profctrl = Get.find<ProfileController>();

  void _saveRecord(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await profctrl.postrecord();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record saved successfully')),
      );
      // Navigator.pop(context);
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
