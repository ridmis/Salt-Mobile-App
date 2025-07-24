import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/reusable_components/small_elevated_button.dart';

void showDeletePoolDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => const Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: DeletePoolForm(),
        ),
  );
}

class DeletePoolForm extends StatefulWidget {
  const DeletePoolForm({super.key});

  @override
  State<DeletePoolForm> createState() => _DeletePoolFormState();
}

class _DeletePoolFormState extends State<DeletePoolForm> {
  List<Map<String, dynamic>> lewayaList = [];
  List<Map<String, dynamic>> typeList = [];
  List<Map<String, dynamic>> poolList = [];

  String? selectedLewayaName;
  int? selectedLId;

  String? selectedTypeName;
  int? selectedTId;

  String? selectedPoolName;
  int? selectedPId;

  @override
  void initState() {
    super.initState();
    fetchLewayas();
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

  void fetchTypes(int lewayaId) async {
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

    setState(() {
      typeList = temp;
      selectedTypeName = null;
      poolList = [];
    });
  }

  void fetchPools(int lId, int tId) async {
    final dbRef = FirebaseDatabase.instance.ref().child('Pools/$lId/$tId');
    final snapshot = await dbRef.get();

    List<Map<String, dynamic>> temp = [];
    if (snapshot.exists) {
      final data = snapshot.value;
      if (data is List) {
        for (int i = 0; i < data.length; i++) {
          final item = data[i];
          if (item != null && item['P_Name'] != null) {
            temp.add({
              'index': i,
              'P_Id': item['P_Id'],
              'P_Name': item['P_Name'],
            });
          }
        }
      }
    }

    setState(() {
      poolList = temp;
      selectedPoolName = null;
    });
  }

  void _deletePool() async {
    if (selectedLId == null || selectedTId == null || selectedPId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        // const SnackBar(content: Text('Please select Lewaya, Type, and Pool')),
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
            "Please select Lewaya, Type and Pool to delete",
            style: smallTextStyle.copyWith(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref().child(
      'Pools/$selectedLId/$selectedTId',
    );
    final snapshot = await dbRef.get();

    if (snapshot.exists && snapshot.value is List) {
      List poolData = snapshot.value as List;
      for (int i = 0; i < poolData.length; i++) {
        final item = poolData[i];
        if (item != null && item['P_Id'].toString() == selectedPId.toString()) {
          await dbRef.child('$i').remove();
          break;
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      // SnackBar(content: Text('Pool "$selectedPoolName" deleted'))
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
          "Pool $selectedPoolName deleted",
          style: smallTextStyle.copyWith(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delete Pool', style: headingTextStyle),
            const SizedBox(height: 20),
            Text('Please select the Lewaya', style: smallTextStyle),
            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedLewayaName,
              items:
                  lewayaList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['name'],
                      child: Text(item['name']),
                    );
                  }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedLewayaName = val;
                  selectedLId =
                      lewayaList.firstWhere((e) => e['name'] == val)['L_ID'];
                  fetchTypes(selectedLId!);
                });
              },
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
                // labelText: 'Select Current Name',
                // labelStyle: smallTextStyle,
                hint: Row(
                  children: [
                    Icon(Icons.my_location_rounded),
                    SizedBox(width: 15),
                    Text("Select", style: smallTextStyle),
                  ],
                ),
              ),
              dropdownColor: greyColor,
              style: smallTextStyle,
            ),
            const SizedBox(height: 20),
            Text('Please select the Type', style: smallTextStyle),
            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedTypeName,
              items:
                  typeList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['Type_Name'],
                      child: Text(item['Type_Name']),
                    );
                  }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedTypeName = val;
                  selectedTId =
                      typeList.firstWhere((e) => e['Type_Name'] == val)['T_Id'];
                  fetchPools(selectedLId!, selectedTId!);
                });
              },
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
                // labelText: 'Select Current Name',
                // labelStyle: smallTextStyle,
                hint: Row(
                  children: [
                    Icon(Icons.menu_open_rounded),
                    SizedBox(width: 15),
                    Text("Select", style: smallTextStyle),
                  ],
                ),
              ),
              dropdownColor: greyColor,
              style: smallTextStyle,
            ),
            const SizedBox(height: 20),
            Text('Please select the Pool', style: smallTextStyle),
            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedPoolName,
              items:
                  poolList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['P_Name'],
                      child: Text(item['P_Name']),
                    );
                  }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedPoolName = val;
                  selectedPId =
                      poolList.firstWhere((e) => e['P_Name'] == val)['P_Id'];
                });
              },
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
                // labelText: 'Select Current Name',
                // labelStyle: smallTextStyle,
                hint: Row(
                  children: [
                    Icon(Icons.menu_open_rounded),
                    SizedBox(width: 15),
                    Text("Select", style: smallTextStyle),
                  ],
                ),
              ),
              dropdownColor: greyColor,
              style: smallTextStyle,
            ),

            const SizedBox(height: 35),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: _deletePool,
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: AppColors.secondary,
            //         foregroundColor: AppColors.thirtary,
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 24,
            //           vertical: 12,
            //         ),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //         elevation: 6,
            //       ),
            //       child: const Text('Delete'),
            //     ),
            //     TextButton(
            //       onPressed: () => Navigator.pop(context),
            //       child: const Text(
            //         'Cancel',
            //         style: TextStyle(color: AppColors.thirtary),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 25),
                Expanded(
                  child: SmallElevatedButton(
                    title: "Delete",
                    onPressed: _deletePool,
                    color: redColor,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SmallElevatedButton(
                    title: "Cancel",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: darkGreyColor,
                  ),
                ),
                SizedBox(width: 25),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
