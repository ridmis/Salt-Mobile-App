import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;

import 'package:myapp/reusable_components/profile_drawer.dart';

class SelectBrineScreen extends StatefulWidget {
  const SelectBrineScreen({super.key});

  @override
  State<SelectBrineScreen> createState() => _SelectBrineScreenState();
}

class _SelectBrineScreenState extends State<SelectBrineScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> lewayaList = [];

  @override
  void initState() {
    super.initState();
    _loadLewayaData();
  }

  void _loadLewayaData() async {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('Lewaya');
      final snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;
        List<Map<String, dynamic>> tempList = [];

        data.forEach((key, value) {
          if (value != null && value['L_ID'] != null && value['name'] != null) {
            final id = value['L_ID'];
            final name = value['name'];
            tempList.add({'L_ID': id, 'name': name});
          }
        });

        setState(() {
          lewayaList = tempList;
        });
      }
    } catch (e) {
      print('Error loading lewaya data: $e');
      // Handle error appropriately in production
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
                      Text(
                        "Baume Readings",
                        style: headingTextStyle.copyWith(fontSize: 20),
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

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      "Factory List",
                      style: headingTextStyle.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: lewayaList.length,
                  itemBuilder: (context, index) {
                    final item = lewayaList[index];
                    return Column(
                      children: [
                        lewayaCard(
                          context,
                          item['name'],
                          onPressed: () {
                            global.selectedLId = item['L_ID'];
                            global.SelectedLName = item['name'];
                            Navigator.pushNamed(
                              context,
                              '/selecttype',
                              arguments: item,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget lewayaCard(
  BuildContext context,
  String name, {
  required VoidCallback onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,

    child: Container(
      height: MediaQuery.of(context).size.height * .18,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/IMG_0666-scaled.jpg"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.18,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: headingTextStyle.copyWith(color: whiteColor),
                    ),
                    Text(
                      "Hambantota",
                      style: smallTextStyle.copyWith(color: whiteColor),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
