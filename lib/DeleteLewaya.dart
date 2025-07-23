import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/reusable_components/small_elevated_button.dart';

void showDeleteLewayaDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => const Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: DeleteLewayaForm(),
        ),
  );
}

class DeleteLewayaForm extends StatefulWidget {
  const DeleteLewayaForm({super.key});

  @override
  State<DeleteLewayaForm> createState() => _DeleteLewayaFormState();
}

class _DeleteLewayaFormState extends State<DeleteLewayaForm> {
  List<Map<String, dynamic>> lewayaList = [];
  String? selectedLewayaId;
  String? selectedLewayaName;

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
      List<Map<String, dynamic>> tempList = [];

      data.forEach((key, value) {
        tempList.add({'key': key, 'name': value['name']});
      });

      setState(() {
        lewayaList = tempList;
      });
    }
  }

  void deleteLewaya() async {
    if (selectedLewayaId != null && selectedLewayaName != null) {
      final dbRef = FirebaseDatabase.instance
          .ref()
          .child('Lewaya')
          .child(selectedLewayaId!);
      await dbRef.remove();

      ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar(content: Text('Lewaya "$selectedLewayaName" deleted')),
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
            "Lewaya $selectedLewayaName deleted",
            style: smallTextStyle.copyWith(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        // const SnackBar(content: Text('Please select a Lewaya to delete')),
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
            "Please select a Lewaya to delete",
            style: smallTextStyle.copyWith(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delete Lewaya', style: headingTextStyle),
            const SizedBox(height: 20),
            Text('Please select the Lewaya', style: smallTextStyle),
            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedLewayaId,
              items:
                  lewayaList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['key'],
                      child: Text(item['name']),
                    );
                  }).toList(),
              onChanged: (value) {
                final selected = lewayaList.firstWhere(
                  (item) => item['key'] == value,
                );
                setState(() {
                  selectedLewayaId = value;
                  selectedLewayaName = selected['name'];
                });
              },
              dropdownColor: greyColor,

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
              style: smallTextStyle,
            ),

            // const SizedBox(height: 20),

            // ElevatedButton(
            //   onPressed: deleteLewaya,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppColors.secondary,
            //     foregroundColor: AppColors.thirtary,
            //     padding: const EdgeInsets.symmetric(vertical: 14),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     elevation: 6,
            //   ),
            //   child: const Text(
            //     'Delete Lewaya',
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ),

            // TextButton(
            //   onPressed: () => Navigator.pop(context),
            //   child: const Text(
            //     'Cancel',
            //     style: TextStyle(color: Colors.white70),
            //   ),
            // ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 25),
                Expanded(
                  child: SmallElevatedButton(
                    title: "Delete",
                    onPressed: deleteLewaya,
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
