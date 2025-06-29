import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';

void showAddTypeDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => const Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: AddTypeForm(),
        ),
  );
}

class AddTypeForm extends StatefulWidget {
  const AddTypeForm({super.key});

  @override
  State<AddTypeForm> createState() => _AddTypeFormState();
}

class _AddTypeFormState extends State<AddTypeForm> {
  final TextEditingController _typeController = TextEditingController();

  List<Map<String, dynamic>> lewayaList = [];
  String? selectedLewayaName;
  int? selectedLId;

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

  void _addType() async {
    String typeName = _typeController.text.trim();

    if (selectedLId == null || typeName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a Lewaya and enter a Type name'),
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
      SnackBar(
        content: Text('Type "$typeName" added to "$selectedLewayaName"'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(24),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Type',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: AppColors.thirtary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Lewaya Dropdown
            DropdownButtonFormField<String>(
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
                      lewayaList.firstWhere((e) => e['name'] == val)['L_ID'];
                });
              },
              dropdownColor: AppColors.secondary,
              style: const TextStyle(color: AppColors.thirtary),
              decoration: _inputDecoration('Select Lewaya'),
            ),

            const SizedBox(height: 20),

            // Type name field
            TextField(
              controller: _typeController,
              style: const TextStyle(color: AppColors.thirtary),
              decoration: _inputDecoration('Type Name'),
            ),

            const SizedBox(height: 24),

            // Add button
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: _addType,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.thirtary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                ),
                child: const Text(
                  'Add Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: AppColors.thirtary),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.thirtary),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.thirtary, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
