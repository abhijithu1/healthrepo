import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helthrepov1/auth/loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Health Repo',
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      getPages: [GetPage(name: "/login", page: () => const LoginPage())],
    );
  }
}
