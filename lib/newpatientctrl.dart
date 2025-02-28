import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helthrepov1/constant.dart';

class NewPatientController extends GetxController {
  final fullnamectrl = TextEditingController();
  final fname = "".obs;
  final age = 0.obs;
  final agectrl = TextEditingController();
  final GetConnect getcon = GetConnect(
    allowAutoSignedCert:
        true, // Allow self-signed certificates (for testing only)
  );
  final box = GetStorage();

  final _baseurl = Constants.baseurl;
  final gender = "Male".obs;

  Future<dynamic> postpatient() async {
    final token = await box.read("token");
    final id = await box.read("id");
    try {
      final Response res = await getcon.post(
        "${_baseurl}api/patients/",
        {
          "name": fname.value,
          "age": age.value,
          "gender": gender.value,
          "doctor": id, // Correctly passing the doctor ID
        },
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json", // Ensure the content type is set
        },
      );

      debugPrint("API Response Status Code: ${res.statusCode}");
      debugPrint("API Response Body: ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        debugPrint("Created new patient successfully: ${res.body}");
        return res.body;
      } else {
        debugPrint("Cannot create patient. Status Code: ${res.statusCode}");
        debugPrint("Response Body: ${res.body}");
      }
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception("Error: $e");
    }
  }
}
