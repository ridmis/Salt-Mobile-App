import 'package:flutter/material.dart';
import 'package:myapp/AppColors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/global.dart' as global;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void login() async {
    final inputUser = _userController.text.trim();
    final inputPass = _passController.text.trim();

    final userRef = FirebaseDatabase.instance.ref().child('users/$inputUser');
    final adminRef = FirebaseDatabase.instance.ref().child('Admin/$inputUser');

    final userSnap = await userRef.get();
    final adminSnap = await adminRef.get();

    // Check Admin node first
    if (adminSnap.exists) {
      final data = adminSnap.value as Map;
      final storedPass = data['password'];

      if (inputPass == storedPass) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Admin login successful")));
        Navigator.pushNamed(context, '/admin');
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid password for admin")),
        );
        _passController.clear();
        return;
      }
    }

    // Check User node
    if (userSnap.exists) {
      final data = userSnap.value as Map;
      final storedPass = data['password'];

      if (inputPass == storedPass) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User login successful")));
        global.userId = data['userId'];
        Navigator.pushNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid password")));
        _passController.clear();
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid username")));
      _userController.clear();
      _passController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(200),
                    bottomRight: Radius.circular(200),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.thirtary,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _userController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              hintText: "Employer ID",
                              filled: true,
                              fillColor: const Color.fromARGB(
                                255,
                                193,
                                188,
                                188,
                              ).withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _passController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              hintText: "Password",
                              filled: true,
                              fillColor: AppColors.thirtary.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: AppColors.thirtary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 30,
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
