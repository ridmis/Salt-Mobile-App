import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/reusable_components/components.dart';
import 'package:myapp/reusable_components/small_elevated_button.dart';

void showUpdateLewayaDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => const Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: UpdateLewayaForm(),
        ),
  );
}

class UpdateLewayaForm extends StatefulWidget {
  const UpdateLewayaForm({super.key});

  @override
  State<UpdateLewayaForm> createState() => _UpdateLewayaFormState();
}

class _UpdateLewayaFormState extends State<UpdateLewayaForm> {
  final TextEditingController _newController = TextEditingController();

  List<Map<String, dynamic>> lewayaList = [];
  String? selectedLewayaName;
  String? selectedLewayaKey;

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
        tempList.add({'key': key, 'name': value['name']});
      });

      setState(() {
        lewayaList = tempList;
      });
    }
  }

  void _updateLewaya() async {
    String newName = _newController.text.trim();

    if (selectedLewayaName == null ||
        newName.isEmpty ||
        selectedLewayaKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        // const SnackBar(
        //   content: Text('Please select a Lewaya and enter a new name'),
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
            "Please select a Lewaya and enter a new name",
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
      'Lewaya/$selectedLewayaKey',
    );
    await dbRef.update({'name': newName});

    ScaffoldMessenger.of(context).showSnackBar(
      // SnackBar(content: Text('"$selectedLewayaName" updated to "$newName"')),
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
          "$selectedLewayaName updated to $newName",
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
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text('Update Lewaya', style: headingTextStyle),
            const SizedBox(height: 20),
            Text('Please select the Lewaya', style: smallTextStyle),
            const SizedBox(height: 15),

            // Dropdown for current name
            DropdownButtonFormField<String>(
              // itemHeight: 30,

              // elevation: 4,
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
                  selectedLewayaKey =
                      lewayaList.firstWhere(
                        (element) => element['name'] == val,
                      )['key'];
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

            // New name field
            // TextField(
            //   controller: _newController,
            //   style: const TextStyle(color: AppColors.thirtary),
            //   decoration: InputDecoration(
            //     labelText: 'New Name',
            //     labelStyle: const TextStyle(color: AppColors.thirtary),
            //     enabledBorder: OutlineInputBorder(
            //       borderSide: const BorderSide(color: AppColors.thirtary),
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: const BorderSide(
            //         color: AppColors.thirtary,
            //         width: 2,
            //       ),
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            // ),
            CustomTextField(
              controller: _newController,
              hintText: "New Name",
              icon: Icons.message_rounded,
              readOnly: false,
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 25),
                Expanded(
                  child: SmallElevatedButton(
                    title: "Update",
                    onPressed: _updateLewaya,
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

            // Buttons
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: _updateLewaya,
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
          ],
        ),
      ),
    );
  }
}
