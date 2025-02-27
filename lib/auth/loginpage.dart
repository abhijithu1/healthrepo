import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helthrepov1/auth/authctrl.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController lgn = Get.find<LoginController>();
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: _width * 0.05, right: _width * 0.05),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: _height * 0.35),
                  const SizedBox(height: 25),
                  SizedBox(
                    child: TextField(
                      controller: lgn.usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.person_3_outlined,
                          color: Color.fromARGB(
                            255,
                            224,
                            6,
                            6,
                          ), // BayMax's theme color (calm blue)
                        ),
                        fillColor: const Color.fromARGB(
                          255,
                          253,
                          247,
                          247,
                        ), // Light, soothing background color
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              216,
                              3,
                              3,
                            ), // Themed border color
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              240,
                              9,
                              9,
                            ), // Slightly darker for focus
                            width: 2.0,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: const BorderSide(
                            color: Colors.grey, // Grey for disabled state
                            width: 0.5,
                          ),
                        ),
                        hintText: "Username",
                        hintStyle: const TextStyle(
                          color: Color(0xFFB0BEC5), // Light grey for hint
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(
                          0xFF0A8FDC,
                        ), // Themed text color for user input
                        fontWeight: FontWeight.bold,
                      ),
                      cursorColor: Color(
                        0xFF0A8FDC,
                      ), // Cursor color matching the theme
                    ),
                  ),
                  SizedBox(height: _height * 0.02),
                  SizedBox(
                    // height: 20,
                    child: TextField(
                      controller: lgn.passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color.fromARGB(
                            255,
                            224,
                            6,
                            6,
                          ), // BayMax's theme color (red)
                        ),
                        fillColor: const Color.fromARGB(
                          255,
                          253,
                          247,
                          247,
                        ), // Light, soothing background color
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              216,
                              3,
                              3,
                            ), // Themed border color
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              240,
                              9,
                              9,
                            ), // Slightly darker for focus
                            width: 2.0,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: const BorderSide(
                            color: Colors.grey, // Grey for disabled state
                            width: 0.5,
                          ),
                        ),
                        hintText: "Password",
                        hintStyle: const TextStyle(
                          color: Color(0xFFB0BEC5), // Light grey for hint
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(
                          0xFF0A8FDC,
                        ), // Themed text color for user input
                        fontWeight: FontWeight.bold,
                      ),
                      cursorColor: Color(
                        0xFF0A8FDC,
                      ), // Cursor color matching the theme
                    ),
                  ),
                  SizedBox(height: _height * 0.05),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        253,
                        247,
                        247,
                      ), // Light background color
                      borderRadius: BorderRadius.circular(50), // Circular shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Changes shadow position
                        ),
                      ],
                    ),
                    child: Material(
                      color:
                          Colors.transparent, // Transparent to show background
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          50,
                        ), // Match the container's border radius
                        splashColor: const Color.fromARGB(
                          255,
                          241,
                          238,
                          238,
                        ).withOpacity(0.3), // Smooth red splash
                        onTap: () async {
                          await lgn.getKey();
                          debugPrint("Pass1");
                          final token = await lgn.box.read("token");
                          debugPrint("Pass2: $token");
                          if (token != null) {
                            Get.toNamed("/home");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(
                            12.0,
                          ), // Add padding around the icon
                          child: Icon(
                            Icons
                                .arrow_forward, // Icon suitable for login action
                            color: Color.fromARGB(
                              255,
                              224,
                              6,
                              6,
                            ), // BayMax theme red color
                            size: 30.0, // Icon size
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
