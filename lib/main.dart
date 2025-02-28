import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helthrepov1/controllers/viewrecctrl.dart';
import 'package:helthrepov1/screens/addnewpatient.dart';
import 'package:helthrepov1/screens/addnewrec.dart';
import 'package:helthrepov1/screens/alertnot.dart';
import 'package:helthrepov1/controllers/authctrl.dart';
import 'package:helthrepov1/screens/loginpage.dart';
import 'package:helthrepov1/screens/chronic.dart';
import 'package:helthrepov1/screens/dashb.dart';
import 'package:helthrepov1/controllers/dashctrl.dart';
import 'package:helthrepov1/controllers/newpatientctrl.dart';
import 'package:helthrepov1/screens/patientprofile.dart';
import 'package:helthrepov1/controllers/profilectrl.dart';
import 'package:helthrepov1/screens/viewrec.dart';

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
  final ProfileController psp = Get.put(ProfileController());
  final ViewRecController vrcc = Get.put(ViewRecController());

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
        GetPage(name: "/viewrec", page: () => const ViewRecordsScreen()),
      ],
    );
  }
}
