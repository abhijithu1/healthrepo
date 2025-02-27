import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class AddNewRecordScreen extends StatefulWidget {
  const AddNewRecordScreen({Key? key}) : super(key: key);

  @override
  _AddNewRecordScreenState createState() => _AddNewRecordScreenState();
}

class _AddNewRecordScreenState extends State<AddNewRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _labResultsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Vital signs controllers
  final TextEditingController _bpController = TextEditingController();
  final TextEditingController _hrController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();

  List<Map<String, dynamic>> _uploadedFiles = [];

  // For stepper functionality
  int _currentStep = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          for (var file in result.files) {
            _uploadedFiles.add({
              'name': file.name,
              'size': '${(file.size / 1024).toStringAsFixed(2)} KB',
              'path': file.path,
            });
          }
        });
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking files: $e')));
    }
  }

  void _removeFile(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
    });
  }

  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      // Process data and save record
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record saved successfully')),
      );
      Navigator.pop(context);
    }
  }

  List<Step> getSteps() {
    return [
      Step(
        title: const Text('Diagnosis'),
        content: Column(
          children: [
            _buildDateField(),
            const SizedBox(height: 16),
            _buildDiagnosisField(),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Treatment'),
        content: Column(
          children: [
            _buildTreatmentField(),
            const SizedBox(height: 16),
            _buildMedicationsField(),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Lab Results & Vitals'),
        content: Column(
          children: [
            _buildLabResultsField(),
            const SizedBox(height: 16),
            _buildVitalSignsFields(),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text('Files & Notes'),
        content: Column(
          children: [
            _buildUploadSection(),
            const SizedBox(height: 16),
            _buildNotesField(),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
    ];
  }

  Widget _buildSimpleForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDateField(),
          const SizedBox(height: 16),
          _buildDiagnosisField(),
          const SizedBox(height: 16),
          _buildTreatmentField(),
          const SizedBox(height: 16),
          _buildMedicationsField(),
          const SizedBox(height: 16),
          _buildLabResultsField(),
          const SizedBox(height: 16),
          _buildVitalSignsFields(),
          const SizedBox(height: 16),
          _buildNotesField(),
          const SizedBox(height: 24),
          _buildUploadSection(),
          const SizedBox(height: 32),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Visit Date',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(DateFormat.yMMMMd().format(_selectedDate)),
      ),
    );
  }

  Widget _buildDiagnosisField() {
    return TextFormField(
      controller: _diagnosisController,
      decoration: const InputDecoration(
        labelText: 'Diagnosis',
        hintText: 'e.g., Diabetes Type 2',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.medical_services),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter diagnosis';
        }
        return null;
      },
    );
  }

  Widget _buildTreatmentField() {
    return TextFormField(
      controller: _treatmentController,
      decoration: const InputDecoration(
        labelText: 'Treatment',
        hintText: 'e.g., Insulin Therapy',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.healing),
      ),
      maxLines: 3,
    );
  }

  Widget _buildMedicationsField() {
    return TextFormField(
      controller: _medicationsController,
      decoration: const InputDecoration(
        labelText: 'Medications',
        hintText: 'e.g., Metformin 500mg, twice daily',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.medication),
      ),
      maxLines: 3,
    );
  }

  Widget _buildLabResultsField() {
    return TextFormField(
      controller: _labResultsController,
      decoration: const InputDecoration(
        labelText: 'Lab Results',
        hintText: 'e.g., HbA1c: 6.5%',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.science),
      ),
      maxLines: 3,
    );
  }

  Widget _buildVitalSignsFields() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vital Signs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _bpController,
                    decoration: const InputDecoration(
                      labelText: 'Blood Pressure',
                      hintText: 'e.g., 120/80',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _hrController,
                    decoration: const InputDecoration(
                      labelText: 'Heart Rate',
                      hintText: 'e.g., 72 bpm',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tempController,
              decoration: const InputDecoration(
                labelText: 'Temperature',
                hintText: 'e.g., 98.6 °F',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notes',
        hintText: 'Additional observations or comments',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.note),
      ),
      maxLines: 4,
    );
  }

  Widget _buildUploadSection() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attachments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickFiles,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Files'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ..._uploadedFiles.asMap().entries.map((entry) {
              int idx = entry.key;
              Map<String, dynamic> file = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(file['name']),
                  subtitle: Text(file['size']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFile(idx),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
        ElevatedButton(
          onPressed: _saveRecord,
          child: const Text('Save', style: TextStyle(fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A73E8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Toggle between stepper and simple form
    bool useStepperView = true; // Set to false to use simple form

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Record'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          useStepperView
              ? Stepper(
                type: StepperType.horizontal,
                currentStep: _currentStep,
                onStepContinue: () {
                  final lastStepIndex = getSteps().length - 1;
                  if (_currentStep < lastStepIndex) {
                    setState(() {
                      _currentStep += 1;
                    });
                  } else {
                    _saveRecord();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                steps: getSteps(),
                controlsBuilder: (context, details) {
                  final lastStepIndex = getSteps().length - 1;
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        if (_currentStep > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Back'),
                          ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A73E8),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            _currentStep == lastStepIndex ? 'Save' : 'Next',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
              : _buildSimpleForm(),
    );
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _medicationsController.dispose();
    _labResultsController.dispose();
    _notesController.dispose();
    _bpController.dispose();
    _hrController.dispose();
    _tempController.dispose();
    super.dispose();
  }
}
