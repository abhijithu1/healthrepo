import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helthrepov1/addnewpatient.dart';
import 'package:helthrepov1/addnewrec.dart';
import 'package:helthrepov1/alertnot.dart';
import 'package:helthrepov1/auth/authctrl.dart';
import 'package:helthrepov1/auth/loginpage.dart';
import 'package:helthrepov1/chronic.dart';
import 'package:helthrepov1/dashb.dart';
import 'package:helthrepov1/dashctrl.dart';
import 'package:helthrepov1/newpatientctrl.dart';
import 'package:helthrepov1/patientprofile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  Get.put<GetConnect>(GetConnect());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final storage = GetStorage();
  final LoginController lgn = Get.put(LoginController());
  final DashBoardController dsb = Get.put(DashBoardController());
  final NewPatientController nsp = Get.put(NewPatientController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Health Repo',
      debugShowCheckedModeBanner: false,
      initialRoute: lgn.box.read("token") == null ? "/login" : "/dash",
      getPages: [
        GetPage(name: "/login", page: () => const LoginPage()),
        GetPage(name: "/dash", page: () => const DashBoard()),

        GetPage(name: "/pp", page: () => const PatientProfile()),
        GetPage(name: "/anrc", page: () => AddNewRecordScreen()),

        GetPage(
          name: "/chronic",
          page: () => const ChronicConditionMonitoringScreen(),
        ),
        GetPage(
          name: "/alert",
          page: () => const AlertsAndNotificationsScreen(),
        ),
        GetPage(name: "/addnp", page: () => const AddNewPatientScreen()),
      ],
    );
  }
}
