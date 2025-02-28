import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helthrepov1/constant.dart';

class DashBoardController extends GetxController {
  final GetConnect getcon = Get.find<GetConnect>();
  final box = GetStorage();
  final _baseurl = Constants.baseurl;

  Future<List<dynamic>> getPatients() async {
    try {
      final token = await box.read("token");
      final Response res = await getcon.get(
        "${_baseurl}api/patients/",
        headers: {"Authorization": "Token $token"},
      );

      if (res.statusCode == 200) {
        debugPrint("The data is ${res.body.toString()}");
        // res.body is already a List<dynamic>, so return it directly
        return res.body;
      } else {
        debugPrint("Can't retrieve: Status code ${res.statusCode}");
        throw Exception("Failed to load patients: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching patients: $e");
      throw Exception("Failed to load patients: $e");
    }
  }
}
