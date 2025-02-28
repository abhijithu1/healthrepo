import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helthrepov1/controllers/dashctrl.dart';
import 'package:intl/intl.dart';
import 'package:helthrepov1/constant.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helthrepov1/controllers/dashctrl.dart';
import 'package:intl/intl.dart';
import 'package:helthrepov1/constant.dart';
import 'package:file_picker/file_picker.dart';

class ChatController extends GetxController {
  final GetConnect getcon = GetConnect(
    allowAutoSignedCert:
        true, // Allow self-signed certificates (for testing only)
  );
  final box = GetStorage();
  final _baseurl = Constants.baseurl;

  final RxString messageText = ''.obs;
  final RxBool isAiTyping = false.obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final Rx<Patient?> selectedPatient = Rx<Patient?>(null);
  final RxList<Patient> patients = <Patient>[].obs;
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load patients from the backend API
    loadPatients();
  }

  void loadPatients() async {
    final dsb = Get.find<DashBoardController>();
    final patientList = await dsb.getPatients();

    // Extract only the name and id from the response
    patients.value =
        patientList.map((patient) {
          return Patient(
            id: patient['id'],
            name: patient['name'],
            abhaId: '', // You can leave this empty or set a default value
            profilePic: '', // You can leave this empty or set a default value
          );
        }).toList();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
  }

  void selectPatient(Patient patient) {
    selectedPatient.value = patient;
    isSearching.value = false;
    // In a real app, fetch chat history for this patient
    messages.clear();
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty || selectedPatient.value == null) return;

    // Add user message to chat
    final userMessage = ChatMessage(
      text: text,
      isFromUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);
    messageText.value = '';

    // Show AI is typing
    isAiTyping.value = true;

    try {
      // Send to backend
      final response = await postpatient(text);

      // Add AI response to chat
      final aiMessage = ChatMessage(
        text: response['response'] ?? "Sorry, I couldn't process that request.",
        isFromUser: false,
        timestamp: DateTime.now(),
      );

      // Add slight delay to simulate AI thinking
      await Future.delayed(const Duration(milliseconds: 500));
      messages.add(aiMessage);
    } catch (e) {
      // Handle error
      final errorMessage = ChatMessage(
        text: "Sorry, an error occurred. Please try again.",
        isFromUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(errorMessage);
    } finally {
      isAiTyping.value = false;
    }
  }

  Future<dynamic> postpatient(String prompt) async {
    final token = await box.read("token");
    try {
      final Response res = await getcon.post(
        "${_baseurl}api/chat/", // Updated API endpoint
        {
          "patient_id":
              selectedPatient.value?.id ?? 0, // Use selected patient's ID
          "prompt": prompt, // Use the user's message as the prompt
        },
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("API Response Status Code: ${res.statusCode}");
      debugPrint("API Response Body: ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        debugPrint("Received AI response: ${res.body}");
        return res.body; // Return the AI's response
      } else {
        debugPrint("Failed to get AI response. Status Code: ${res.statusCode}");
        debugPrint("Response Body: ${res.body}");
        return {"response": "Error communicating with AI"};
      }
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception("Error: $e");
    }
  }

  void attachFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        // Handle file attachment
        final fileName = result.files.first.name;
        sendMessage("Attached file: $fileName");
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }
}

class Patient {
  final int id;
  final String name;
  final String abhaId;
  final String profilePic;

  Patient({
    required this.id,
    required this.name,
    required this.abhaId,
    required this.profilePic,
  });
}

class ChatMessage {
  final String text;
  final bool isFromUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isFromUser,
    required this.timestamp,
  });
}

class AiChatScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());
  final FocusNode _focusNode = FocusNode();

  AiChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('AI Chat', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Patient Selection Section
          _buildPatientSelection(),

          // Divider
          const Divider(height: 1),

          // Chat Window
          Obx(
            () =>
                controller.selectedPatient.value == null
                    ? _buildNoPatientSelectedView()
                    : _buildChatWindow(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoPatientSelectedView() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_search, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Select a patient to start chatting',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientSelection() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar (now just toggles patient list)
          InkWell(
            onTap: () => controller.toggleSearch(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'Search patients',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),

          // Patient List
          Obx(
            () =>
                controller.isSearching.value
                    ? _buildPatientList()
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientList() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: controller.patients.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final patient = controller.patients[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(patient.profilePic),
            ),
            title: Text(
              patient.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('ID: ${patient.id}'),
            onTap: () {
              controller.selectPatient(patient);
              FocusScope.of(context).unfocus();
            },
          );
        },
      ),
    );
  }

  Widget _buildChatWindow() {
    return Expanded(
      child: Container(
        color: Colors.grey.shade50,
        child: Column(
          children: [
            // Selected Patient Indicator
            Obx(
              () =>
                  controller.selectedPatient.value != null
                      ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        color: Colors.white,
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Get.theme.primaryColor,
                              radius: 16,
                              child: Text(
                                controller.selectedPatient.value!.profilePic,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.selectedPatient.value!.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'ID: ${controller.selectedPatient.value!.id}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed:
                                  () => controller.selectedPatient.value = null,
                            ),
                          ],
                        ),
                      )
                      : const SizedBox.shrink(),
            ),

            // Messages
            Expanded(
              child: Obx(
                () =>
                    controller.messages.isEmpty
                        ? Center(
                          child: Text(
                            'Start a conversation with AI',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.messages.length,
                          reverse: false,
                          itemBuilder: (context, index) {
                            final message = controller.messages[index];
                            return _buildMessageBubble(message);
                          },
                        ),
              ),
            ),

            // Typing Indicator
            Obx(
              () =>
                  controller.isAiTyping.value
                      ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'AI is typing...',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
            ),

            // Input Bar
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isFromUser = message.isFromUser;
    final formatter = DateFormat('h:mm a');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isFromUser
                        ? const Color(0xFF1A73E8)
                        : const Color(0xFF34A853),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatter.format(message.timestamp),
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          if (isFromUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attachment Button
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () => controller.attachFile(),
            color: Colors.grey.shade600,
          ),

          // Text Input
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              onChanged: (value) => controller.messageText.value = value,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.sendMessage(value);
                  _focusNode.requestFocus();
                }
              },
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),

          // Send Button
          Obx(
            () => IconButton(
              icon: const Icon(Icons.send),
              onPressed:
                  controller.messageText.value.trim().isEmpty
                      ? null
                      : () {
                        controller.sendMessage(controller.messageText.value);
                        _focusNode.requestFocus();
                      },
              color:
                  controller.messageText.value.trim().isEmpty
                      ? Colors.grey.shade400
                      : const Color(0xFF1A73E8),
            ),
          ),
        ],
      ),
    );
  }
}
