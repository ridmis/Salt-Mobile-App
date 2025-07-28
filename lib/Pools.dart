import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;
import 'package:myapp/reusable_components/profile_drawer.dart';

class SelectPool extends StatefulWidget {
  const SelectPool({super.key});

  @override
  State<SelectPool> createState() => _SelectPoolState();
}

class _SelectPoolState extends State<SelectPool> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String name = global.SelectedLName;
  List<Map<String, dynamic>> poolList = [];
  Set<int> washedOutPoolIds = {}; // Track submitted pools

  @override
  void initState() {
    super.initState();
    selectPool();
  }

  void selectPool() async {
    int selectedLId = global.selectedLId;
    int selectedTypeId = global.SelectedTypeId;

    final dbRef = FirebaseDatabase.instance.ref().child(
      'Pools/$selectedLId/$selectedTypeId',
    );
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value;
      List<Map<String, dynamic>> tempList = [];

      if (data is List) {
        for (var item in data) {
          if (item != null &&
              item is Map &&
              item['P_Name'] != null &&
              item['P_Id'] != null) {
            tempList.add({
              'name': item['P_Name'],
              'P_Id': int.tryParse(item['P_Id'].toString()) ?? 0,
            });
          }
        }
      } else if (data is Map) {
        data.forEach((key, value) {
          if (value != null &&
              value['P_Name'] != null &&
              value['P_Id'] != null) {
            tempList.add({
              'name': value['P_Name'],
              'P_Id': int.tryParse(value['P_Id'].toString()) ?? 0,
            });
          }
        });
      }

      setState(() {
        poolList = tempList;
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
      // body: SafeArea(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       const SizedBox(height: 10),
      //       Text(
      //         'Select the number',
      //         style: TextStyle(
      //           fontSize: 26,
      //           fontWeight: FontWeight.bold,
      //           color: AppColors.secondary,
      //         ),
      //       ),
      //       const SizedBox(height: 30),
      //       Expanded(
      //         child: GridView.count(
      //           padding: const EdgeInsets.symmetric(horizontal: 40),
      //           crossAxisCount: 3,
      //           crossAxisSpacing: 20,
      //           mainAxisSpacing: 20,
      //           children:
      //               poolList.map((pool) {
      //                 final poolId = pool['P_Id'];
      //                 final isWashedOut = washedOutPoolIds.contains(poolId);

      //                 return ElevatedButton(
      //                   onPressed:
      //                       isWashedOut
      //                           ? null
      //                           : () async {
      //                             global.selectedPId = poolId;
      //                             global.selectedPoolName = pool['name'];

      //                             final result = await Navigator.pushNamed(
      //                               context,
      //                               '/mbasin',
      //                               arguments: poolId.toString(),
      //                             );

      //                             if (result != null && result is String) {
      //                               setState(() {
      //                                 washedOutPoolIds.add(poolId);
      //                               });
      //                             }
      //                           },
      //                   style: ElevatedButton.styleFrom(
      //                     backgroundColor:
      //                         isWashedOut ? Colors.grey : AppColors.thirtary,
      //                     foregroundColor: AppColors.primary,
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(20),
      //                     ),
      //                     textStyle: const TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                       fontSize: 18,
      //                     ),
      //                   ),
      //                   child: Text(
      //                     isWashedOut
      //                         ? '${pool['name']} (Washed Out)'
      //                         : pool['name'] ?? '',
      //                   ),
      //                 );
      //               }).toList(),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    image: AssetImage("assets/istock-484942148.jpg"),
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
                      child: Text(
                        "Select ${global.selectedTypeName} Number",
                        style: headingTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Please select the number of ${global.selectedTypeName}",
                        style: smallTextStyle,
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      // crossAxisCount: 3,
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children:
                          poolList.map((pool) {
                            final poolId = pool['P_Id'];
                            final isWashedOut = washedOutPoolIds.contains(
                              poolId,
                            );

                            return ElevatedButton(
                              onPressed:
                                  isWashedOut
                                      ? null
                                      : () async {
                                        global.selectedPId = poolId;
                                        global.selectedPoolName = pool['name'];

                                        final result =
                                            await Navigator.pushNamed(
                                              context,
                                              '/mbasin',
                                              arguments: poolId.toString(),
                                            );

                                        if (result != null &&
                                            result is String) {
                                          setState(() {
                                            washedOutPoolIds.add(poolId);
                                          });
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isWashedOut ? blueColor2 : greyColor,
                                foregroundColor: blackColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: headingTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              child: Text(
                                isWashedOut
                                    ? '${pool['name']} (Washed Out)'
                                    : pool['name'] ?? '',
                              ),
                            );
                          }).toList(),
                    ),
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
