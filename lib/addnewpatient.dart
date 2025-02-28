import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helthrepov1/dashctrl.dart';
import 'package:helthrepov1/newpatientctrl.dart';
import 'package:intl/intl.dart';

class AddNewPatientScreen extends StatelessWidget {
  const AddNewPatientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final npctrl = Get.find<NewPatientController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Patient',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildBody() {
    final npctrl = Get.find<NewPatientController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
            'Full Name*',
            'Enter patient full name',
            TextInputType.name,
            npctrl.fullnamectrl,
          ),
          _buildFormField(
            'Age*',
            'Enter patient age',
            TextInputType.number,
            npctrl.agectrl,
          ),
          _buildDatePicker(),
          _buildGenderDropdown(),

          const SizedBox(height: 20),
          const Text(
            'Contact Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          _buildFormField(
            'Phone Number*',
            'Enter phone number',
            TextInputType.phone,
            TextEditingController(),
          ),
          _buildFormField(
            'Email',
            'Enter email address',
            TextInputType.emailAddress,
            TextEditingController(),
          ),
          _buildFormField(
            'Address',
            'Enter patient address',
            TextInputType.streetAddress,
            TextEditingController(),
          ),
          _buildFormField(
            'ABHA ID',
            'Enter Ayushman Bharat Health Account ID (Optional)',
            TextInputType.text,
            TextEditingController(),
          ),

          const SizedBox(height: 20),
          const Text(
            'Emergency Contact',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          _buildFormField(
            'Name*',
            'Enter emergency contact name',
            TextInputType.name,
            TextEditingController(),
          ),
          _buildFormField(
            'Phone Number*',
            'Enter emergency contact phone number',
            TextInputType.phone,
            TextEditingController(),
          ),

          const SizedBox(height: 20),
          const Text(
            'Medical History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          _buildFormField(
            'Allergies',
            'List any known allergies',
            TextInputType.text,
            TextEditingController(),
          ),
          _buildFormField(
            'Chronic Conditions',
            'List any chronic conditions',
            TextInputType.text,
            TextEditingController(),
          ),

          _buildNotesField(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    String hint,
    TextInputType keyboardType,
    TextEditingController txtctrl,
  ) {
    final bool isRequired = label.contains('*');
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextFormField(
              controller: txtctrl,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF1A73E8),
                    width: 2,
                  ),
                ),
              ),
              validator:
                  isRequired
                      ? (value) =>
                          value == null || value.isEmpty
                              ? 'This field is required'
                              : null
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date of Birth*',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Select date of birth',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF1A73E8),
                    width: 2,
                  ),
                ),
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF1A73E8),
                ),
              ),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: const Color(0xFF1A73E8),
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF1A73E8),
                        ),
                        buttonTheme: const ButtonThemeData(
                          textTheme: ButtonTextTheme.primary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  controller.text = dateFormat.format(picked);
                }
              },
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Date of birth is required'
                          : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    final genderOptions = ['Male', 'Female', 'Other'];
    final selected = Rx<String?>(null);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gender*',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Obx(
              () => DropdownButtonFormField<String>(
                value: selected.value,
                hint: const Text('Select gender'),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF1A73E8),
                      width: 2,
                    ),
                  ),
                ),
                items:
                    genderOptions.map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                onChanged: (String? value) {
                  final npctrl = Get.find<NewPatientController>();

                  selected.value = value;
                  npctrl.gender.value = selected.value!;
                },
                validator:
                    (value) => value == null ? 'Gender is required' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Notes',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter any additional notes or observations',
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF1A73E8),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    final npctrl = Get.find<NewPatientController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5F6368),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Cancel', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                final dbc = Get.find<DashBoardController>();
                if (npctrl.fullnamectrl.text.trim().isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Name cannot be empty!",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                npctrl.fname.value = npctrl.fullnamectrl.text.trim();
                npctrl.age.value =
                    int.tryParse(npctrl.agectrl.text.trim()) ?? 0;
                await npctrl.postpatient();
                await dbc.getPatients();
                Get.offNamed("/dash");
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
