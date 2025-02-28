import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helthrepov1/constant.dart';

class ViewRecController extends GetxController {
  final GetConnect getcon = GetConnect(
    allowAutoSignedCert:
        true, // Allow self-signed certificates (for testing only)
  );
  final box = GetStorage();

  final _baseurl = Constants.baseurl;
  final id = 1.obs;

  final name = "john Doe".obs;

  Future<List<dynamic>> getRecords() async {
    try {
      final token = await box.read("token");
      final Response res = await getcon.get(
        "${_baseurl}api/records/${id.value}",
        headers: {"Authorization": "Token $token"},
      );

      if (res.statusCode == 200) {
        debugPrint("The data is ${res.body.toString()}");
        // res.body is already a List<dynamic>, so return it directly
        return res.body;
      } else {
        debugPrint("Can't retrieve: Status code ${res.statusCode}");
        throw Exception("Failed to load records: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching records: $e");
      throw Exception("Failed to load records: $e");
    }
  }

  var refreshTrigger = false.obs;

  void refreshFuture() {
    refreshTrigger.value =
        !refreshTrigger.value; // Toggle value to trigger FutureBuilder
  }

  // @override
  // void onInit() {
  //   getRecords(); // Fetch records when the controller initializes
  //   super.onInit();
  // }
}
