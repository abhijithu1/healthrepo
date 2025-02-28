import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helthrepov1/constant.dart';

class ProfileController extends GetxController {
  final id = 0.obs;
  final name = "".obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController recordTypeController = TextEditingController();
  final GetConnect getcon = GetConnect(
    allowAutoSignedCert:
        true, // Allow self-signed certificates (for testing only)
  );
  final box = GetStorage();

  final _baseurl = Constants.baseurl;

  Future<dynamic> postrecord() async {
    final token = await box.read("token");

    // Check if token exists
    if (token == null || token.isEmpty) {
      debugPrint("Error: Authentication token is missing");
      return null;
    }

    try {
      // Add timeout to detect connection issues
      getcon.timeout = const Duration(seconds: 30);

      final Response res = await getcon.post(
        "${_baseurl}api/records/",
        {
          "id": id.value,
          "name": nameController.text,
          "url": urlController.text,
          "record_type": recordTypeController.text,
        },
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("API Response Status Code: ${res.statusCode}");
      debugPrint("API Response Body: ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        debugPrint("Created new record successfully: ${res.body}");
        return res.body;
      } else {
        debugPrint("Cannot create record. Status Code: ${res.statusCode}");
        debugPrint("Response Body: ${res.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Connection Error: $e");
      // Return a more specific error
      return {"error": "Connection failed: $e"};
    }
  }
}
