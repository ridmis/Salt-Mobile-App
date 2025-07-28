import 'package:flutter/material.dart';
import 'package:myapp/UpdateLewaya.dart';
import 'package:myapp/UpdateType.dart';
import 'package:myapp/UpdatePool.dart';
import 'package:myapp/DeleteLewaya.dart';
import 'package:myapp/DeleteTypes.dart';
import 'package:myapp/DeletePool.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;
import 'package:myapp/reusable_components/change_current_item_container.dart';
import 'package:myapp/reusable_components/profile_drawer.dart';

class ChangeItems extends StatefulWidget {
  const ChangeItems({super.key});

  @override
  State<ChangeItems> createState() => _ChangeItemsState();
}

class _ChangeItemsState extends State<ChangeItems> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<String> imageUrl = [
      "assets/IMG_8656-scaled.jpg",
      "assets/what_is_salt_made_of_1024x1024.webp",
      "assets/Hambantota-Salt-Factory-Tour-from-Hambantota-Port-2.jpg",
    ];
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "Change Current Items",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: AppColors.primary,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(color: Colors.white),
      // ),
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
                  // radius: MediaQuery.of(context).size.width * 0.06,
                  radius: 30,
                  backgroundImage: AssetImage("assets/Sample_User_Icon.png"),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Change Current Items", style: headingTextStyle),
              SizedBox(height: 30),
              ChangeCurrentItemContainer(
                image: imageUrl[0],
                title: "Lewaya",
                onUpdate: () {
                  showUpdateLewayaDialog(context);
                },
                onDelete: () {
                  showDeleteLewayaDialog(context);
                },
              ),
              SizedBox(height: 20),
              ChangeCurrentItemContainer(
                image: imageUrl[1],
                title: "Type",
                onUpdate: () {
                  showUpdateTypeDialog(context);
                },
                onDelete: () {
                  showDeleteTypeDialog(context);
                },
              ),
              SizedBox(height: 20),
              ChangeCurrentItemContainer(
                image: imageUrl[2],
                title: "Pool",
                onUpdate: () {
                  showUpdatePoolDialog(context);
                },
                onDelete: () {
                  showDeletePoolDialog(context);
                },
              ),

              // Container(
              //   width: double.infinity,
              //   height: double.infinity,
              //   decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //       colors: [AppColors.primary, AppColors.secondary],
              //     ),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(24.0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         const SizedBox(height: 40),
              //         _styledButton(context, "Update Lewaya", () {
              //           showUpdateLewayaDialog(context);
              //         }),
              //         const SizedBox(height: 16),
              //         _styledButton(context, "Update Type", () {
              //           showUpdateTypeDialog(context);
              //         }),
              //         const SizedBox(height: 16),
              //         _styledButton(context, "Update Pool", () {
              //           showUpdatePoolDialog(context);
              //         }),
              //         const SizedBox(height: 40), // Extra space
              //         _styledButton(context, "Delete Lewaya", () {
              //           showDeleteLewayaDialog(context);
              //         }),
              //         const SizedBox(height: 16),
              //         _styledButton(context, "Delete Type", () {
              //           showDeleteTypeDialog(context);
              //         }),

              //         const SizedBox(height: 16),
              //         _styledButton(context, "Delete Pool", () {
              //           showDeletePoolDialog(context);
              //         }),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _styledButton(
  //   BuildContext context,
  //   String text,
  //   VoidCallback onPressed,
  // ) {
  //   return ElevatedButton(
  //     onPressed: onPressed,
  //     style: ElevatedButton.styleFrom(
  //       padding: const EdgeInsets.symmetric(vertical: 18),
  //       backgroundColor: Colors.white.withOpacity(0.95),
  //       foregroundColor: AppColors.primary,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       elevation: 6,
  //       shadowColor: Colors.black45,
  //       textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //     ),
  //     child: Text(text),
  //   );
  // }
}
