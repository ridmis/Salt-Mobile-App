import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/AppColors.dart';
import 'package:myapp/AddPools.dart';
import 'package:myapp/AddTypes.dart';
import 'package:myapp/AddLewaya.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;
import 'package:myapp/reusable_components/components.dart';
import 'package:myapp/reusable_components/create_new_item_container.dart';
import 'package:myapp/reusable_components/large_elevated_button.dart';
import 'package:myapp/reusable_components/profile_drawer.dart';

class CreateItems extends StatefulWidget {
  CreateItems({super.key});

  @override
  State<CreateItems> createState() => _CreateItemsState();
}

class _CreateItemsState extends State<CreateItems> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _lewayaController = TextEditingController();

  // For add Lewaya
  void _addLewaya() async {
    String lewayaName = _lewayaController.text.trim();

    if (lewayaName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        // const SnackBar(content: Text('Please enter a Lewaya name')),
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
            "Please enter a name for Lewaya",
            style: smallTextStyle.copyWith(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref().child('Lewaya');
    final snapshot = await dbRef.get();

    int nextId = 1;
    String newKey = 'L1';

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      List<int> ids = [];

      data.forEach((key, value) {
        if (value['L_ID'] != null) {
          ids.add(int.tryParse(value['L_ID'].toString()) ?? 0);
        }
      });

      if (ids.isNotEmpty) {
        nextId = ids.reduce((a, b) => a > b ? a : b) + 1;
        newKey = 'L$nextId';
      }
    }

    await dbRef.child(newKey).set({'L_ID': nextId, 'name': lewayaName});

    ScaffoldMessenger.of(context).showSnackBar(
      // SnackBar(content: Text('Lewaya "$lewayaName" added'),),);
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
          "Successfully added $lewayaName Lewaya.",
          style: smallTextStyle.copyWith(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    Navigator.pop(context);
  }

  // for Add New Type
  final TextEditingController _typeController = TextEditingController();

  List<Map<String, dynamic>> lewayaList = [];
  String? selectedLewayaName;
  int? selectedLId;

  @override
  void initState() {
    super.initState();
    fetchLewayas();
    fetchLewayasforPool();
  }

  void fetchLewayas() async {
    final dbRef = FirebaseDatabase.instance.ref().child('Lewaya');
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      List<Map<String, dynamic>> temp = [];

      data.forEach((key, value) {
        temp.add({'name': value['name'], 'L_ID': value['L_ID']});
      });

      setState(() {
        lewayaList = temp;
      });
    }
  }

  void _addType() async {
    String typeName = _typeController.text.trim();

    if (selectedLId == null || typeName.isEmpty) {
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
            "Please select a Lewaya and Enter the Type",
            style: smallTextStyle.copyWith(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref().child('Types/$selectedLId');
    final snapshot = await dbRef.get();

    int nextTId = 1;
    List existing = [];

    if (snapshot.exists) {
      final data = snapshot.value;
      if (data is List) {
        existing = data.where((e) => e != null).toList();
        if (existing.isNotEmpty) {
          final ids =
              existing
                  .map((e) => int.tryParse(e['T_Id'].toString()) ?? 0)
                  .toList();
          nextTId = ids.reduce((a, b) => a > b ? a : b) + 1;
        }
      }
    }

    await dbRef.update({
      '$nextTId': {'T_Id': nextTId, 'Type_Name': typeName},
    });

    ScaffoldMessenger.of(context).showSnackBar(
      // SnackBar(
      //   content: Text('Type "$typeName" added to "$selectedLewayaName"'),
      // ),
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
          "Type $typeName added to ${selectedLewayaName} Lewaya",
          style: smallTextStyle.copyWith(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    Navigator.pop(context);
  }

  // Add new Pool
  final TextEditingController _poolController = TextEditingController();

  List<Map<String, dynamic>> lewayaListforPool = [];
  List<Map<String, dynamic>> typeList = [];

  String? selectedLewayaNameforPool;
  int? selectedLIdforPool;

  String? selectedTypeName;
  int? selectedTId;

  void fetchLewayasforPool() async {
    final dbRef = FirebaseDatabase.instance.ref().child('Lewaya');
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      List<Map<String, dynamic>> tempList = [];
      data.forEach((key, value) {
        tempList.add({'name': value['name'], 'L_ID': value['L_ID']});
      });

      setState(() {
        lewayaListforPool = tempList;
      });
    }
  }

  void fetchTypes(int lewayaId) async {
    // First clear everything to ensure UI updates
    setState(() {
      typeList = []; // Clear the list first
      selectedTypeName = null;
      selectedTId = null;
    });

    // Add a small delay to ensure the UI updates before fetching new data
    await Future.delayed(Duration(milliseconds: 100));

    // Then fetch new data
    final dbRef = FirebaseDatabase.instance.ref().child('Types/$lewayaId');
    final snapshot = await dbRef.get();

    List<Map<String, dynamic>> temp = [];
    if (snapshot.exists) {
      final data = snapshot.value;
      if (data is List) {
        for (var item in data) {
          if (item != null &&
              item['T_Id'] != null &&
              item['Type_Name'] != null) {
            temp.add({'T_Id': item['T_Id'], 'Type_Name': item['Type_Name']});
          }
        }
      }
    }

    // Force rebuild with the new data
    if (mounted) {
      setState(() {
        typeList = temp;
      });
    }
  }

  void _addPool() async {
    final poolName = _poolController.text.trim();

    if (selectedLIdforPool == null || selectedTId == null || poolName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select Lewaya, Type, and enter Pool name'),
        ),
      );
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref().child(
      'Pools/$selectedLIdforPool/$selectedTId',
    );
    final snapshot = await dbRef.get();

    int newPid = 1;
    if (snapshot.exists && snapshot.value is List) {
      List poolList = snapshot.value as List;
      newPid = poolList.where((e) => e != null).length + 1;
    }

    final newPool = {
      'P_Id': newPid,
      'P_Name': poolName,
      'L_Id': selectedLIdforPool,
      'T_Id': selectedTId,
    };

    await dbRef.child('$newPid').set(newPool);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pool "$poolName" added successfully')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageUrl = [
      "assets/IMG_8656-scaled.jpg",
      "assets/what_is_salt_made_of_1024x1024.webp",
      "assets/Hambantota-Salt-Factory-Tour-from-Hambantota-Port-2.jpg",
    ];

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
                  backgroundImage: AssetImage("assets/salt.png"),
                ),
              ),
            ],
          ),
        ),
      ),
      // body: Container(
      //   decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [AppColors.primary, AppColors.secondary],
      //     ),
      //   ),
      //   child: SafeArea(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //         // Top bar with back button and title
      //         Padding(
      //           padding: const EdgeInsets.symmetric(
      //             horizontal: 8.0,
      //             vertical: 12,
      //           ),
      //           child: Row(
      //             children: [
      //               IconButton(
      //                 icon: const Icon(
      //                   Icons.arrow_back,
      //                   color: AppColors.thirtary,
      //                 ),
      //                 onPressed: () {
      //                   Navigator.of(context).pop();
      //                 },
      //               ),
      //               const SizedBox(width: 8),
      //               const Text(
      //                 'Create New Items',
      //                 style: TextStyle(
      //                   color: AppColors.thirtary,
      //                   fontSize: 24,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),

      //         Expanded(
      //           child: SingleChildScrollView(
      //             padding: const EdgeInsets.symmetric(horizontal: 24.0),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.stretch,
      //               children: [
      //                 _buildStyledButton("Add Lewaya", () {
      //                   showAddLewayaDialog(context);
      //                 }),
      //                 const SizedBox(height: 16),
      //                 _buildStyledButton("Add Type", () {
      //                   showAddTypeDialog(context);
      //                 }),
      //                 const SizedBox(height: 16),
      //                 _buildStyledButton("Add Pool", () {
      //                   showAddPoolDialog(
      //                     context,
      //                   ); // Show dialog instead of navigation
      //                 }),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text("Create New Item", style: headingTextStyle),
              SizedBox(height: 30),
              CreateNewItemContainer(
                onTap: () {
                  addLewayaBottumSheet(context);
                },
                image: imageUrl[0],
                title: "Add New",
                subtitle: "Lewaya",
              ),
              SizedBox(height: 20),
              CreateNewItemContainer(
                onTap: () {
                  addTypeBottumSheet(context);
                },
                image: imageUrl[1],
                title: "Add New",
                subtitle: "Type",
              ),
              SizedBox(height: 20),
              CreateNewItemContainer(
                onTap: () {
                  addPoolBottumSheet(context);
                },
                image: imageUrl[2],
                title: "Add New",
                subtitle: "Pool",
              ),

              //               showModalBottomSheet(
              //   context: context,
              //   backgroundColor: Colors.transparent,
              //   builder: (context) => BackdropFilter(
              //     filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              //     child: Container(
              //       width: MediaQuery.of(context).size.width,
              //       height: 440,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              //       ),
              //       child: Column(),// Your content here
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> addLewayaBottumSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // isScrollControlled: true,
      builder:
          (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
              child: Scaffold(
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 440,
                  // height: MediaQuery.of(context).size.height * .2,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(45),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 40,
                      vertical: 75,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Add New Lewaya", style: headingTextStyle),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: _lewayaController,
                          hintText: "Enter Name",
                          icon: Icons.home_work_outlined,
                          readOnly: false,
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 35),
                        Row(
                          children: [
                            Expanded(
                              child: LargeElevatedButton(
                                title: "Add",
                                onPressed: () {
                                  _addLewaya();
                                },
                              ),
                            ),
                            SizedBox(width: 20),

                            Expanded(
                              child: LargeElevatedButton(
                                title: "Cancel",
                                onPressed: () => Navigator.pop(context),
                                color: darkGreyColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Future<dynamic> addTypeBottumSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // isScrollControlled: true,
      builder:
          (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
              child: Scaffold(
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 440,
                  // height: MediaQuery.of(context).size.height * .2,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(45),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 40,
                      vertical: 75,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Add New Type", style: headingTextStyle),
                        SizedBox(height: 20),
                        Text("Please select a Lewaya", style: smallTextStyle),
                        SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          hint: Row(
                            children: [
                              Icon(Icons.location_searching_rounded),
                              SizedBox(width: 15),
                              Text("Select", style: smallTextStyle),
                            ],
                          ),
                          value: selectedLewayaName,
                          items:
                              lewayaList.map((lewaya) {
                                return DropdownMenuItem<String>(
                                  value: lewaya['name'],
                                  child: Text(lewaya['name']),
                                );
                              }).toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedLewayaName = val;
                              selectedLId =
                                  lewayaList.firstWhere(
                                    (e) => e['name'] == val,
                                  )['L_ID'];
                            });
                          },
                          dropdownColor: greyColor,
                          style: smallTextStyle,
                          decoration: _inputDecoration(''),
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: _typeController,
                          hintText: "Enter Name",

                          icon: Icons.menu_open_rounded,
                          readOnly: false,
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 35),
                        Row(
                          children: [
                            Expanded(
                              child: LargeElevatedButton(
                                title: "Add",
                                onPressed: () {
                                  _addType();
                                },
                              ),
                            ),
                            SizedBox(width: 20),

                            Expanded(
                              child: LargeElevatedButton(
                                title: "Cancel",
                                onPressed: () => Navigator.pop(context),
                                color: darkGreyColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Future<dynamic> addPoolBottumSheet(BuildContext context) {
    // Create local copies of the state variables for the bottom sheet
    String? localSelectedLewayaName = selectedLewayaNameforPool;
    int? localSelectedLewayaId = selectedLIdforPool;
    String? localSelectedTypeName = selectedTypeName;
    int? localSelectedTypeId = selectedTId;
    List<Map<String, dynamic>> localTypeList = [];

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setBottomSheetState) {
              // Function to fetch types within the bottom sheet
              void fetchLocalTypes(int lewayaId) async {
                // Clear types first
                setBottomSheetState(() {
                  localTypeList = [];
                  localSelectedTypeName = null;
                  localSelectedTypeId = null;
                });

                // Fetch new types
                final dbRef = FirebaseDatabase.instance.ref().child(
                  'Types/$lewayaId',
                );
                final snapshot = await dbRef.get();

                List<Map<String, dynamic>> temp = [];
                if (snapshot.exists) {
                  final data = snapshot.value;
                  if (data is List) {
                    for (var item in data) {
                      if (item != null &&
                          item['T_Id'] != null &&
                          item['Type_Name'] != null) {
                        temp.add({
                          'T_Id': item['T_Id'],
                          'Type_Name': item['Type_Name'],
                        });
                      }
                    }
                  }
                }

                // Update the local type list
                setBottomSheetState(() {
                  localTypeList = temp;
                });
              }

              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: Container(
                        // height: 440,
                        width: MediaQuery.of(context).size.width,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(45),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 75,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add New Pool", style: headingTextStyle),
                              SizedBox(height: 20),
                              Text(
                                "Please select a Lewaya",
                                style: smallTextStyle,
                              ),
                              SizedBox(height: 15),
                              DropdownButtonFormField<String>(
                                hint: Row(
                                  children: [
                                    Icon(Icons.location_searching_rounded),
                                    SizedBox(width: 15),
                                    Text("Select", style: smallTextStyle),
                                  ],
                                ),
                                value: localSelectedLewayaName,
                                items:
                                    lewayaListforPool.map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item['name'],
                                        child: Text(item['name']),
                                      );
                                    }).toList(),
                                onChanged: (val) {
                                  // Update local state
                                  localSelectedLewayaName = val;
                                  localSelectedLewayaId =
                                      lewayaListforPool.firstWhere(
                                        (e) => e['name'] == val,
                                      )['L_ID'];

                                  // Fetch types with the local function
                                  fetchLocalTypes(localSelectedLewayaId!);

                                  // Update parent state too
                                  setState(() {
                                    selectedLewayaNameforPool = val;
                                    selectedLIdforPool = localSelectedLewayaId;
                                  });
                                },
                                decoration: _inputDecoration(''),
                                dropdownColor: greyColor,
                                style: smallTextStyle,
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Please select a Type",
                                style: smallTextStyle,
                              ),
                              SizedBox(height: 15),
                              DropdownButtonFormField<String>(
                                key: ValueKey(localSelectedLewayaId),
                                hint: Row(
                                  children: [
                                    Icon(Icons.menu_open_rounded),
                                    SizedBox(width: 15),
                                    Text("Select", style: smallTextStyle),
                                  ],
                                ),
                                value: localSelectedTypeName,
                                items:
                                    localTypeList.isEmpty
                                        ? []
                                        : localTypeList.map((item) {
                                          return DropdownMenuItem<String>(
                                            value: item['Type_Name'],
                                            child: Text(item['Type_Name']),
                                          );
                                        }).toList(),
                                onChanged:
                                    localTypeList.isEmpty
                                        ? null
                                        : (val) {
                                          setBottomSheetState(() {
                                            localSelectedTypeName = val;
                                            localSelectedTypeId =
                                                localTypeList.firstWhere(
                                                  (e) => e['Type_Name'] == val,
                                                )['T_Id'];
                                          });

                                          // Update parent state too
                                          setState(() {
                                            selectedTypeName = val;
                                            selectedTId = localSelectedTypeId;
                                          });
                                        },
                                decoration: _inputDecoration(''),
                                dropdownColor: greyColor,
                                style: smallTextStyle,
                              ),
                              SizedBox(height: 20),
                              CustomTextField(
                                controller: _poolController,
                                hintText: "Enter Name",
                                icon: Icons.menu_open_rounded,
                                readOnly: false,
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 35),
                              Row(
                                children: [
                                  Expanded(
                                    child: LargeElevatedButton(
                                      title: "Add",
                                      onPressed: () {
                                        _addPool();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: LargeElevatedButton(
                                      title: "Cancel",
                                      onPressed: () => Navigator.pop(context),
                                      color: darkGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildStyledButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.thirtary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String label) => InputDecoration(
  labelText: label,
  labelStyle: smallTextStyle,
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
);
