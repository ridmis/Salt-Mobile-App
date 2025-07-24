import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;
import 'package:myapp/reusable_components/components.dart';
import 'package:myapp/reusable_components/large_elevated_button.dart';
import 'package:myapp/reusable_components/profile_drawer.dart';

class AddUserAdmin extends StatefulWidget {
  @override
  _AddUserAdminState createState() => _AddUserAdminState();
}

class _AddUserAdminState extends State<AddUserAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _obscureText = true;
  String selectedRole = 'Admin';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void _addUserOrAdmin() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
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
            "Please enter username and password",
            style: smallTextStyle.copyWith(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
      // SnackBar(content: Text('$selectedRole "$username" added successfully')),
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
          "Successfully added ${selectedRole} - $username",
          style: smallTextStyle.copyWith(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    usernameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ProfileDrawer(),
      appBar: AppBar(
        shadowColor: blackColor,
        elevation: 2,
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        backgroundColor: greyColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${global.userName}",
                            style: headingTextStyle.copyWith(fontSize: 20),
                          ),
                          Text(global.userType, style: smallTextStyle),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: CircleAvatar(
                  backgroundColor: whiteColor,
                  radius: MediaQuery.of(context).size.width * 0.06,
                  backgroundImage: AssetImage("assets/Sample_User_Icon.png"),
                ),
              ),
            ],
          ),
        ),
      ),
      // body: Container(
      //   decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       colors: [
      //         AppColors.primary,
      //         AppColors.secondary,
      //         AppColors.thirtary,
      //       ],
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //     ),
      //   ),
      //   padding: const EdgeInsets.all(20.0),
      //   child: Column(
      //     children: [
      //       DropdownButtonFormField<String>(
      //         value: selectedRole,
      //         dropdownColor: AppColors.primary,
      //         style: const TextStyle(color: AppColors.thirtary),
      //         decoration: const InputDecoration(
      //           labelText: 'Select Role',
      //           labelStyle: TextStyle(color: AppColors.thirtary),
      //           enabledBorder: OutlineInputBorder(
      //             borderSide: BorderSide(color: AppColors.thirtary),
      //           ),
      //           focusedBorder: OutlineInputBorder(
      //             borderSide: BorderSide(color: AppColors.thirtary),
      //           ),
      //         ),
      //         items:
      //             ['Admin', 'User'].map((role) {
      //               return DropdownMenuItem(
      //                 value: role,
      //                 child: Text(
      //                   role,
      //                   style: const TextStyle(color: AppColors.thirtary),
      //                 ),
      //               );
      //             }).toList(),
      //         onChanged: (value) {
      //           setState(() {
      //             selectedRole = value!;
      //           });
      //         },
      //       ),
      //       const SizedBox(height: 20),
      //       TextField(
      //         controller: usernameController,
      //         style: const TextStyle(color: AppColors.thirtary),
      //         decoration: const InputDecoration(
      //           labelText: 'Username',
      //           labelStyle: TextStyle(color: AppColors.thirtary),
      //           enabledBorder: OutlineInputBorder(
      //             borderSide: BorderSide(color: AppColors.thirtary),
      //           ),
      //           focusedBorder: OutlineInputBorder(
      //             borderSide: BorderSide(color: AppColors.thirtary),
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 20),
      //       TextField(
      //         controller: passwordController,
      //         obscureText: true,
      //         style: const TextStyle(color: AppColors.thirtary),
      //         decoration: const InputDecoration(
      //           labelText: 'Password',
      //           labelStyle: TextStyle(color: AppColors.thirtary),
      //           enabledBorder: OutlineInputBorder(
      //             borderSide: BorderSide(color: AppColors.thirtary),
      //           ),
      //           focusedBorder: OutlineInputBorder(
      //             borderSide: BorderSide(color: AppColors.thirtary),
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 30),
      //       ElevatedButton(
      //         onPressed: _addUserOrAdmin,
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: AppColors.primary,
      //           foregroundColor: AppColors.thirtary,
      //           padding: const EdgeInsets.symmetric(
      //             horizontal: 40,
      //             vertical: 12,
      //           ),
      //         ),
      //         child: const Text(
      //           'Add',
      //           style: TextStyle(
      //             color: AppColors.thirtary,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text("Create New User or Admin", style: headingTextStyle),
              SizedBox(height: 30),
              Text("Please Select the Type", style: smallTextStyle),
              SizedBox(height: 15),

              // DropdownButtonFormField<String>(
              //   value: selectedRole,
              //   dropdownColor: greyColor,
              //   style: smallTextStyle,
              //   decoration: InputDecoration(
              //     focusColor: greyColor,

              //     // labelText: 'Select Role',
              //     // labelStyle: TextStyle(color: blackColor),
              //     // enabledBorder: OutlineInputBorder(
              //     //   borderSide: BorderSide(color: greyColor),
              //     // ),
              //     // focusedBorder: OutlineInputBorder(
              //     //   borderSide: BorderSide(color: greyColor),
              //     // ),
              //   ),
              //   items:
              //       ['Admin', 'User'].map((role) {
              //         return DropdownMenuItem(
              //           value: role,
              //           child: Text(role, style: TextStyle(color: blackColor)),
              //         );
              //       }).toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       selectedRole = value!;
              //     });
              //   },
              // ),
              DropdownButtonFormField<String>(
                value: selectedRole,
                dropdownColor: greyColor,
                style: smallTextStyle,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: greyColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                items:
                    [
                      {'role': 'Admin', 'icon': Icons.admin_panel_settings},
                      {'role': 'User', 'icon': Icons.person},
                    ].map((item) {
                      return DropdownMenuItem(
                        value: item['role'] as String,
                        child: Row(
                          children: [
                            Icon(
                              item['icon'] as IconData,
                              color: blackColor,
                              size: 24,
                            ),
                            SizedBox(width: 10),
                            Text(
                              item['role'] as String,
                              style: TextStyle(color: blackColor),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              CustomTextField(
                keyboardType: TextInputType.text,
                readOnly: false,
                controller: usernameController,
                hintText: 'Username',
                icon: Icons.person_outline_rounded,
              ),
              SizedBox(height: 20),
              CustomTextField(
                keyboardType: TextInputType.text,
                readOnly: false,
                controller: passwordController,
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
              SizedBox(height: 40),
              LargeElevatedButton(title: "Create", onPressed: _addUserOrAdmin),
            ],
          ),
        ),
      ),
    );
  }
}
