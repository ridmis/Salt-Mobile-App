import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/reusable_components/small_elevated_button.dart';

void showDeleteTypeDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => const Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: DeleteTypeForm(),
        ),
  );
}

class DeleteTypeForm extends StatefulWidget {
  const DeleteTypeForm({super.key});

  @override
  State<DeleteTypeForm> createState() => _DeleteTypeFormState();
}

class _DeleteTypeFormState extends State<DeleteTypeForm> {
  List<Map<String, dynamic>> lewayaList = [];
  String? selectedLewayaName;
  int? selectedLewayaId;

  List<Map<String, dynamic>> typeList = [];
  String? selectedTypeName;
  String? selectedTypeKey;

  @override
  void initState() {
    super.initState();
    fetchLewayaList();
  }

  void fetchLewayaList() async {
    final dbRef = FirebaseDatabase.instance.ref().child('Lewaya');
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      List<Map<String, dynamic>> tempList = [];

      data.forEach((key, value) {
        tempList.add({
          'key': key,
          'name': value['name'],
          'L_ID': value['L_ID'],
        });
      });

      setState(() {
        lewayaList = tempList;
      });
    }
  }

  void fetchTypes(int lewayaId) async {
    final dbRef = FirebaseDatabase.instance.ref().child('Types/$lewayaId');
    final snapshot = await dbRef.get();

    List<Map<String, dynamic>> tempList = [];
    if (snapshot.exists) {
      final data = snapshot.value;
      if (data is List) {
        for (var item in data) {
          if (item != null && item['Type_Name'] != null) {
            tempList.add({
              'key': item['T_Id'].toString(),
              'name': item['Type_Name'],
            });
          }
        }
      } else if (data is Map) {
        data.forEach((key, value) {
          if (value != null && value['Type_Name'] != null) {
            tempList.add({'key': key, 'name': value['Type_Name']});
          }
        });
      }
    }

    setState(() {
      typeList = tempList;
      selectedTypeName = null;
      selectedTypeKey = null;
    });
  }

  void _deleteType() async {
    if (selectedLewayaId == null || selectedTypeKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        // const SnackBar(content: Text('Please select Lewaya and Type to delete')),
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
            "Please select Lewaya and Type to delete",
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
      'Types/$selectedLewayaId/$selectedTypeKey',
    );
    await dbRef.remove();

    ScaffoldMessenger.of(context).showSnackBar(
      // SnackBar(content: Text('Type "$selectedTypeName" deleted')),
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
          "Type $selectedTypeName deleted",
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
            Text('Delete Type', style: headingTextStyle),
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
                  selectedLewayaId =
                      lewayaList.firstWhere((e) => e['name'] == val)['L_ID'];
                  fetchTypes(selectedLewayaId!);
                });
              },
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
            ),
            const SizedBox(height: 20),
            Text('Please select Type', style: smallTextStyle),
            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedTypeName,
              items:
                  typeList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['name'],
                      child: Text(item['name']),
                    );
                  }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedTypeName = val;
                  selectedTypeKey =
                      typeList.firstWhere((e) => e['name'] == val)['key'];
                });
              },
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
            ),
            const SizedBox(height: 35),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: _deleteType,
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: AppColors.secondary,
            //         foregroundColor: AppColors.thirtary,
            //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //         elevation: 6,
            //       ),
            //       child: const Text('Delete'),
            //     ),
            //     TextButton(
            //       onPressed: () => Navigator.pop(context),
            //       child: const Text('Cancel', style: TextStyle(color: AppColors.thirtary)),
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
                    onPressed: _deleteType,
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
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
