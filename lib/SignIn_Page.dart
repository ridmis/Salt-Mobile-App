// // import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:myapp/AppColors.dart';
// import 'package:myapp/components.dart';
// import 'package:myapp/global.dart' as global;

// class SignIn extends StatefulWidget {
//   const SignIn({super.key});

//   @override
//   State<SignIn> createState() => _SignInState();
// }

// class _SignInState extends State<SignIn> {
//   final TextEditingController _userController = TextEditingController();
//   final TextEditingController _passController = TextEditingController();
//   bool _obscureText = true;

//   void login() async {
//     final inputUser = _userController.text.trim();
//     final inputPass = _passController.text.trim();

//     final userRef = FirebaseDatabase.instance.ref().child('users/$inputUser');
//     final adminRef = FirebaseDatabase.instance.ref().child('Admin/$inputUser');

//     final userSnap = await userRef.get();
//     final adminSnap = await adminRef.get();

//     if (adminSnap.exists) {
//       final data = adminSnap.value as Map;
//       final storedPass = data['password'];

//       if (inputPass == storedPass) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Admin login successful")),
//         );
//         Navigator.pushNamed(context, '/admin');
//         return;
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Invalid password for admin")),
//         );
//         _passController.clear();
//         return;
//       }
//     }

//     if (userSnap.exists) {
//       final data = userSnap.value as Map;
//       final storedPass = data['password'];

//       if (inputPass == storedPass) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User login successful")),
//         );
//         global.userId = data['userId'];
//         Navigator.pushNamed(context, '/dashboard');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Invalid password")),
//         );
//         _passController.clear();
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Invalid username")),
//       );
//       _userController.clear();
//       _passController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           ImageFiltered(
//             imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//             child: Image.asset('assets/Salt_bg.png', fit: BoxFit.cover),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
//               decoration: const BoxDecoration(
//                 color: AppColors.thirtary,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Login", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Please Sign in as an Administrator or User",
//                       style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 87, 86, 86)),
//                     ),
//                     const SizedBox(height: 20),
//                     CustomTextField(
//                       controller: _userController,
//                       hintText: 'Username',
//                       icon: Icons.person,
//                     ),
//                     const SizedBox(height: 16),
//                     CustomTextField(
//                       controller: _passController,
//                       hintText: 'Password',
//                       icon: Icons.lock,
//                       isPassword: true,
//                       obscureText: _obscureText,
//                       togglePasswordVisibility: () {
//                         setState(() {
//                           _obscureText = !_obscureText;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     CustomButton(
//                       label: 'Sign In',
//                       onPressed: login,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;
import 'package:myapp/reusable_components/components.dart';
import 'package:myapp/reusable_components/large_elevated_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscureText = true;

  void login() async {
    final inputUser = _userController.text.trim();
    final inputPass = _passController.text.trim();

    global.userName = inputUser;

    final userRef = FirebaseDatabase.instance.ref().child('users/$inputUser');
    final adminRef = FirebaseDatabase.instance.ref().child('Admin/$inputUser');

    final userSnap = await userRef.get();
    final adminSnap = await adminRef.get();

    if (adminSnap.exists) {
      final data = adminSnap.value as Map;
      final storedPass = data['password'];

      if (inputPass == storedPass) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            backgroundColor: greenColor,

            content: Text(
              textAlign: TextAlign.center,
              "Admin Login Successfull",
              style: smallTextStyle.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        Navigator.pushNamed(context, '/admin');
        global.userType = "Admin";
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            backgroundColor: redColor,

            content: Text(
              textAlign: TextAlign.center,
              "Invalid Password",
              style: smallTextStyle.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        _passController.clear();
        return;
      }
    }

    if (userSnap.exists) {
      final data = userSnap.value as Map;
      final storedPass = data['password'];

      if (inputPass == storedPass) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            backgroundColor: greenColor,

            content: Text(
              textAlign: TextAlign.center,
              "User Login Successfull",
              style: smallTextStyle.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        global.userId = data['userId'];
        Navigator.pushNamed(context, '/dashboard');
        global.userType = "Updater";
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            backgroundColor: redColor,

            content: Text(
              textAlign: TextAlign.center,
              "Invalid Password",
              style: smallTextStyle.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        _passController.clear();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          backgroundColor: redColor,

          content: Text(
            textAlign: TextAlign.center,
            "Invalid Username",
            style: smallTextStyle.copyWith(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      _userController.clear();
      _passController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Image.asset('assets/Epsom-Salts.jpg', fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 440,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              decoration: const BoxDecoration(
                color: AppColors.thirtary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Login", style: headingTextStyle),
                    const SizedBox(height: 8),
                    Text(
                      "Please Sign in as an Administrator or User",
                      style: smallTextStyle,
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      keyboardType: TextInputType.text,
                      readOnly: false,
                      controller: _userController,
                      hintText: 'Username',
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      keyboardType: TextInputType.text,
                      readOnly: false,
                      controller: _passController,
                      hintText: 'Password',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      obscureText: _obscureText,
                      togglePasswordVisibility: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    LargeElevatedButton(title: "Sign in", onPressed: login),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
