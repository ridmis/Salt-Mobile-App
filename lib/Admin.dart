import 'package:flutter/material.dart';
import 'package:myapp/AppColors.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;
import 'package:myapp/reusable_components/dashboard_container.dart';
import 'package:myapp/reusable_components/profile_drawer.dart';

class AdminPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double spacing = 16.0;

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, ${global.userName}",
                        style: headingTextStyle.copyWith(fontSize: 20),
                      ),
                      Text(global.userType, style: smallTextStyle),
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
                  backgroundImage: AssetImage("assets/salt.png"),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Dashboard", style: headingTextStyle),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: DashboardContainer(
                        onTap: () {
                          Navigator.pushNamed(context, "/addUser");
                        },
                        image: "assets/16678169.gif",
                        title: "Add User/Admin",
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: DashboardContainer(
                        onTap: () {
                          Navigator.pushNamed(context, "/createItems");
                        },
                        image: "assets/new-item.gif",
                        title: "Create New Item",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DashboardContainer(
                        image: "assets/prescription.gif",
                        title: "Report",
                        onTap: () {
                          Navigator.pushNamed(context, "/reportSection");
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DashboardContainer(
                        image: "assets/analysis.gif",
                        title: "Analyse",
                        onTap: () {
                          Navigator.pushNamed(context, "/analyseSection");
                        },
                      ),
                    ),
                    // SizedBox(width: 10),
                    // Expanded(
                    //   child: DashboardContainer(
                    //     image: "assets/newspaper.gif",
                    //     title: "Readings",
                    //     onTap: () {
                    //       Navigator.pushNamed(context, "/readingSection");
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: DashboardContainer(
                        image: "assets/update.gif",
                        title: "Change Current Items",
                        onTap: () {
                          Navigator.pushNamed(context, "/changeItems");
                        },
                      ),
                    ),

                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       // 🔹 Background gradient
    //       Container(
    //         decoration: const BoxDecoration(
    //           gradient: LinearGradient(
    //             colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
    //             begin: Alignment.topCenter,
    //             end: Alignment.bottomCenter,
    //           ),
    //         ),
    //       ),

    //       // 🔹 Main content
    //       SafeArea(
    //         child: Padding(
    //           padding: const EdgeInsets.all(24.0),
    //           child: Column(
    //             children: [
    //               const Text(
    //                 "Admin Dashboard",
    //                 style: TextStyle(
    //                   fontSize: 24,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white,
    //                   letterSpacing: 1.2,
    //                 ),
    //               ),
    //               const SizedBox(height: 30),

    //               // First Row
    //               Row(
    //                 children: [
    //                   Expanded(
    //                     child: AspectRatio(
    //                       aspectRatio: 1,
    //                       child: _buildAdminButton(
    //                         context,
    //                         "Add Users & Admins",
    //                         '/addUser',
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(width: spacing),
    //                   Expanded(
    //                     child: AspectRatio(
    //                       aspectRatio: 1,
    //                       child: _buildAdminButton(
    //                         context,
    //                         "Create New Items",
    //                         '/createItems',
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),

    //               SizedBox(height: spacing),

    //               // Second Row (Single Button)
    //               SizedBox(
    //                 width: double.infinity,
    //                 height: 120,
    //                 child: _buildAdminButton(
    //                   context,
    //                   "Report Section",
    //                   '/reportSection',
    //                 ),
    //               ),

    //               SizedBox(height: spacing),

    //               // Third Row
    //               Row(
    //                 children: [
    //                   Expanded(
    //                     child: AspectRatio(
    //                       aspectRatio: 1,
    //                       child: _buildAdminButton(
    //                         context,
    //                         "Analyse Section",
    //                         '/analyseSection',
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(width: spacing),
    //                   Expanded(
    //                     child: AspectRatio(
    //                       aspectRatio: 1,
    //                       child: _buildAdminButton(
    //                         context,
    //                         "Reading Section",
    //                         '/readingSection',
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),

    //               SizedBox(height: spacing),

    //               // Fourth Row (Single Button)
    //               SizedBox(
    //                 width: double.infinity,
    //                 height: 120,
    //                 child: _buildAdminButton(
    //                   context,
    //                   "Change Current Items",
    //                   '/changeItems',
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildAdminButton(BuildContext context, String text, String route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.secondary, width: 3),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
