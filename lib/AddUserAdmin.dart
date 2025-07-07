import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';

class AddUserAdmin extends StatefulWidget {
  @override
  _AddUserAdminState createState() => _AddUserAdminState();
}

class _AddUserAdminState extends State<AddUserAdmin> {
  String selectedRole = 'Admin';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void _addUserOrAdmin() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username and password cannot be empty')),
      );
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref();
    final rolePath = selectedRole == 'Admin' ? 'Admin' : 'users';
    final userData = {
      'username': username,
      'password': password,
      if (selectedRole == 'User') 'userId': username,
    };

    await dbRef.child(rolePath).child(username).set(userData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$selectedRole "$username" added successfully')),
    );

    usernameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Users & Admins',
          style: TextStyle(color: AppColors.thirtary),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.thirtary),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.thirtary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedRole,
              dropdownColor: AppColors.primary,
              style: const TextStyle(color: AppColors.thirtary),
              decoration: const InputDecoration(
                labelText: 'Select Role',
                labelStyle: TextStyle(color: AppColors.thirtary),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.thirtary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.thirtary),
                ),
              ),
              items: ['Admin', 'User'].map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(
                    role,
                    style: const TextStyle(color: AppColors.thirtary),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              style: const TextStyle(color: AppColors.thirtary),
              decoration: const InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: AppColors.thirtary),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.thirtary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.thirtary),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: AppColors.thirtary),
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: AppColors.thirtary),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.thirtary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.thirtary),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _addUserOrAdmin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.thirtary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: AppColors.thirtary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
