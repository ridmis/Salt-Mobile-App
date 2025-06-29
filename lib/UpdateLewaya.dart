import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';

void showUpdateLewayaDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => const Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
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
        const SnackBar(
          content: Text('Please select a Lewaya and enter a new name'),
        ),
      );
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref().child(
      'Lewaya/$selectedLewayaKey',
    );
    await dbRef.update({'name': newName});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"$selectedLewayaName" updated to "$newName"')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Update Lewaya',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.thirtary,
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown for current name
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
                  selectedLewayaKey =
                      lewayaList.firstWhere(
                        (element) => element['name'] == val,
                      )['key'];
                });
              },
              dropdownColor: AppColors.secondary,
              style: const TextStyle(color: AppColors.thirtary),
              decoration: InputDecoration(
                labelText: 'Select Current Name',
                labelStyle: const TextStyle(color: AppColors.thirtary),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.thirtary),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.thirtary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // New name field
            TextField(
              controller: _newController,
              style: const TextStyle(color: AppColors.thirtary),
              decoration: InputDecoration(
                labelText: 'New Name',
                labelStyle: const TextStyle(color: AppColors.thirtary),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.thirtary),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.thirtary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateLewaya,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.thirtary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                  ),
                  child: const Text('Update'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Back',
                    style: TextStyle(color: AppColors.thirtary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
