import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/reusable_components/components.dart';
import 'package:myapp/reusable_components/small_elevated_button.dart';

void showUpdateTypeDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => const Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: UpdateTypeForm(),
        ),
  );
}

class UpdateTypeForm extends StatefulWidget {
  const UpdateTypeForm({super.key});

  @override
  State<UpdateTypeForm> createState() => _UpdateTypeFormState();
}

class _UpdateTypeFormState extends State<UpdateTypeForm> {
  final TextEditingController _newController = TextEditingController();

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

      setState(() {
        typeList = tempList;
        selectedTypeName = null;
      });
    }
  }

  void _updateType() async {
    String newName = _newController.text.trim();

    if (selectedLewayaId == null ||
        selectedTypeKey == null ||
        newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        // const SnackBar(
        //   content: Text('Please select Lewaya, Type and enter new name'),
        // ),
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
            "Please select Lewaya, Type and New name",
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
    await dbRef.update({'Type_Name': newName});

    ScaffoldMessenger.of(context).showSnackBar(
      // SnackBar(content: Text('Type "$selectedTypeName" updated to "$newName"')),
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
          "Type $selectedTypeName updated to $newName",
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
            Text('Update Type', style: headingTextStyle),
            const SizedBox(height: 20),
            Text('Please select the Lewaya', style: smallTextStyle),
            const SizedBox(height: 15),
            // Lewaya Dropdown
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

            // Type Dropdown
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

            const SizedBox(height: 20),

            // New Name Field
            // TextField(
            //   controller: _newController,
            //   style: const TextStyle(color: AppColors.thirtary),
            //   decoration: const InputDecoration(
            //     labelText: 'New Type Name',
            //     labelStyle: TextStyle(color: AppColors.thirtary),
            //     enabledBorder: OutlineInputBorder(
            //       borderSide: BorderSide(color: AppColors.thirtary),
            //       borderRadius: BorderRadius.all(Radius.circular(12)),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: BorderSide(color: AppColors.thirtary, width: 2),
            //       borderRadius: BorderRadius.all(Radius.circular(12)),
            //     ),
            //   ),
            // ),
            CustomTextField(
              controller: _newController,
              hintText: "New Type",
              icon: Icons.message_rounded,
              readOnly: false,
              keyboardType: TextInputType.text,
            ),

            // const SizedBox(height: 20),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: _updateType,
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
            //       child: const Text('Update'),
            //     ),
            //     TextButton(
            //       onPressed: () => Navigator.pop(context),
            //       child: const Text(
            //         'Back',
            //         style: TextStyle(color: AppColors.thirtary),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 25),
                Expanded(
                  child: SmallElevatedButton(
                    title: "Update",
                    onPressed: _updateType,
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
