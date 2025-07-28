import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;
import 'package:myapp/reusable_components/profile_drawer.dart';

class SelectTypeScreen extends StatefulWidget {
  const SelectTypeScreen({super.key});

  @override
  State<SelectTypeScreen> createState() => _SelectTypeScreenState();
}

class _SelectTypeScreenState extends State<SelectTypeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> typesList = [];

  String name = global.SelectedLName;

  @override
  void initState() {
    super.initState();
    selectType();
  }

  void selectType() async {
    int selectedLId = global.selectedLId;
    final dbRef = FirebaseDatabase.instance.ref().child('Types/$selectedLId');
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value;
      List<Map<String, dynamic>> tempList = [];

      if (data is List) {
        for (var item in data) {
          if (item != null && item is Map && item['Type_Name'] != null) {
            tempList.add({'name': item['Type_Name'], 'T_Id': item['T_Id']});
            print(item['Type_Name']);
          }
        }
      } else if (data is Map) {
        data.forEach((key, value) {
          if (value != null && value['Type_Name'] != null) {
            tempList.add({'name': value['Type_Name'], 'T_Id': value['T_Id']});
            print(value['Type_Name']);
          }
        });
      }

      setState(() {
        typesList = tempList;
      });
    }
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
                            "Baume Readings",
                            style: headingTextStyle.copyWith(fontSize: 20),
                          ),
                          Text(
                            name,
                            style: headingTextStyle.copyWith(fontSize: 16),
                          ),
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
      // body: Stack(
      //   children: [

      //     // Main content
      //     SafeArea(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(
      //           horizontal: 24.0,
      //           vertical: 30,
      //         ),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             const SizedBox(height: 40),

      //             // Dynamically create buttons from typesList
      //             ...typesList.map(
      //               (type) => Padding(
      //                 padding: const EdgeInsets.only(bottom: 20.0),
      //                 child: _buildTypeButton(
      //                   context,
      //                   type['name'],
      //                   onPressed: () {
      //                     global.SelectedTypeId = type['T_Id'];
      //                     global.selectedTypeName = type['name'];

      //                     print(global.SelectedTypeId);
      //                     Navigator.pushNamed(context, '/polls');
      //                   },
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.25,
                height:
                    global.isTablet
                        ? MediaQuery.of(context).size.height * 0.30
                        : MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.6),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),

                  image: DecorationImage(
                    image: AssetImage(
                      "assets/Hambantota-Salt-Factory-Tour-from-Hambantota-Port-2.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Select Type", style: headingTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Please select the Type you want to update",
                        style: smallTextStyle,
                      ),
                    ),
                    SizedBox(height: 15),
                    ...typesList.map(
                      (type) => typeButton(
                        context,
                        type['name'],
                        onPressed: () {
                          global.SelectedTypeId = type['T_Id'];
                          global.selectedTypeName = type['name'];

                          print(global.SelectedTypeId);
                          Navigator.pushNamed(context, '/polls');
                        },
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget typeButton(
  BuildContext context,
  String name, {
  required VoidCallback onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        // height: MediaQuery.of(context).size.width * .3,
        height:
            global.isTablet
                ? MediaQuery.of(context).size.height * 0.32
                : MediaQuery.of(context).size.height * 0.20,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/istockphoto-1350872542-612x612.jpg"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              // bottom: -20,
              child: Container(
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      greyColor.withOpacity(.2),
                      blackColor.withOpacity(0.4),
                      blackColor.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(name, style: headingTextStyle.copyWith(color: whiteColor)),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
