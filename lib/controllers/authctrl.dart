import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helthrepov1/constant.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final GetConnect getcon = GetConnect(
    allowAutoSignedCert:
        true, // Allow self-signed certificates (for testing only)
  );
  final box = GetStorage();

  final _baseurl = Constants.baseurl;

  void login() async {
    try {
      await getKey();
    } catch (e) {
      debugPrint("Login error: $e");
      Get.snackbar("Error", "Failed to login. Please try again.");
    }
    try {
      await getCurrentUser();
    } catch (e) {
      debugPrint("Id error: $e");
      Get.snackbar("Error", "Failed to retreive id. Please try again.");
    }
  }

  Future<dynamic> getKey() async {
    try {
      final Response res = await getcon.post("${_baseurl}api/auth/login/", {
        "username": "snape",
        "password": "nandu123",
      });

      debugPrint("API Response Status Code: ${res.statusCode}");
      debugPrint("API Response Body: ${res.body}");

      if (res.statusCode == 200) {
        debugPrint("Login successful: ${res.body}");
        final hardkey = res.body['key'];
        if (hardkey != null) {
          await box.write("token", hardkey);
          Get.toNamed("/dash");
          return res.body;
        } else {
          debugPrint("Key not found in response");
          throw Exception("Key not found in response");
        }
      } else {
        debugPrint("Login failed with status code: ${res.statusCode}");
        debugPrint("Response body: ${res.body}");
        throw Exception("Failed to login: ${res.statusText}");
      }
    } catch (e) {
      debugPrint("Login error: $e");
      throw Exception("Login error: $e");
    }
  }

  Future<dynamic> getCurrentUser() async {
    final token = await box.read("token"); // Retrieve the token from GetStorage
    final Response res = await getcon.get(
      "${_baseurl}api/userProfile/",
      headers: {
        "Authorization": "Token $token",
      }, // Include the token in the headers
    );

    if (res.statusCode == 200) {
      debugPrint("The data is ${res.body.toString()}");

      // Extract the 'id' from the response body
      final userId = res.body['id'];

      // Store the 'id' in GetStorage
      await box.write("id", userId);
      debugPrint("User ID stored: $userId");

      return res.body;
    } else {
      debugPrint("Can't retrieve user data. Status code: ${res.statusCode}");
      throw Exception("Failed to retrieve user data");
    }
  }
}
