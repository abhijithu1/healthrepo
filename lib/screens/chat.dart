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
  final RxList<Patient> filteredPatients = <Patient>[].obs;
  final RxBool isSearching = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load patients from the backend API
    loadPatients();

    // Initialize filtered patients with all patients
    ever(patients, (_) {
      filteredPatients.value = patients;
    });

    // Add listener to searchQuery to filter patients when search text changes
    ever(searchQuery, (_) {
      filterPatients();
    });
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
    if (!isSearching.value) {
      // Clear search when closing
      searchQuery.value = '';
    }
  }

  void filterPatients() {
    if (searchQuery.value.isEmpty) {
      filteredPatients.value = patients;
    } else {
      filteredPatients.value =
          patients
              .where(
                (patient) =>
                    patient.name.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ||
                    patient.id.toString().contains(searchQuery.value),
              )
              .toList();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void selectPatient(Patient patient) {
    selectedPatient.value = patient;
    isSearching.value = false;
    searchQuery.value = '';
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
    messageText.value = ''; // Clear the text field

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
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

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
          // Search Bar
          InkWell(
            onTap: () => controller.toggleSearch(),
            child: Obx(
              () =>
                  controller.isSearching.value
                      ? _buildActiveSearchBar()
                      : _buildInactiveSearchBar(),
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

  Widget _buildInactiveSearchBar() {
    return Container(
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
    );
  }

  Widget _buildActiveSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search by name or ID',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                controller.updateSearchQuery(value);
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                controller.updateSearchQuery('');
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPatientList() {
    return Obx(() {
      final patients = controller.filteredPatients;

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
        child:
            patients.isEmpty
                ? _buildNoResultsFound()
                : ListView.separated(
                  shrinkWrap: true,
                  itemCount: patients.length,
                  separatorBuilder:
                      (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          patient.name.isNotEmpty
                              ? patient.name[0].toUpperCase()
                              : '?',
                        ),
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
    });
  }

  Widget _buildNoResultsFound() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No patients found',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            'Try searching with a different name or ID',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
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
                                controller
                                        .selectedPatient
                                        .value!
                                        .name
                                        .isNotEmpty
                                    ? controller.selectedPatient.value!.name[0]
                                        .toUpperCase()
                                    : '?',
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

  // Helper function to format text with markdown-like syntax
  List<TextSpan> _formatText(String text) {
    List<TextSpan> spans = [];

    // Split the text by the bold pattern (**text**)
    RegExp boldRegExp = RegExp(r'\*\*(.*?)\*\*');

    // Keep track of where we are in the original string
    int lastMatchEnd = 0;

    // Find all bold matches
    for (Match match in boldRegExp.allMatches(text)) {
      // Add any text before this match
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: const TextStyle(color: Colors.white),
          ),
        );
      }

      // Add the bold text (without the ** markers)
      spans.add(
        TextSpan(
          text: match.group(1), // The text between ** and **
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      // Update the lastMatchEnd
      lastMatchEnd = match.end;
    }

    // Add any remaining text after the last match
    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return spans;
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
                  // Use RichText for formatted message content
                  RichText(
                    text: TextSpan(
                      children:
                          isFromUser
                              ? [
                                TextSpan(
                                  text: message.text,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ]
                              : _formatText(message.text),
                    ),
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
            child: Obx(() {
              // Update TextEditingController when messageText changes
              _textController.text = controller.messageText.value;
              // Maintain cursor position at the end
              _textController.selection = TextSelection.fromPosition(
                TextPosition(offset: _textController.text.length),
              );

              return TextField(
                controller: _textController,
                focusNode: _focusNode,
                onChanged: (value) => controller.messageText.value = value,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    controller.sendMessage(value);
                    _textController
                        .clear(); // Clear text controller after sending
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
              );
            }),
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
                        _textController
                            .clear(); // Clear text controller after sending
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
