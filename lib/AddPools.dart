import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';

void showAddPoolDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const AddPoolForm(),
      );
    },
  );
}

class AddPoolForm extends StatefulWidget {
  const AddPoolForm({super.key});

  @override
  State<AddPoolForm> createState() => _AddPoolFormState();
}

class _AddPoolFormState extends State<AddPoolForm> {
  final TextEditingController _poolController = TextEditingController();

  List<Map<String, dynamic>> lewayaList = [];
  List<Map<String, dynamic>> typeList = [];

  String? selectedLewayaName;
  int? selectedLId;

  String? selectedTypeName;
  int? selectedTId;

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
        tempList.add({'name': value['name'], 'L_ID': value['L_ID']});
      });

      setState(() {
        lewayaList = tempList;
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
    });
  }

  void _addPool() async {
    final poolName = _poolController.text.trim();

    if (selectedLId == null || selectedTId == null || poolName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select Lewaya, Type, and enter Pool name'),
        ),
      );
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref().child(
      'Pools/$selectedLId/$selectedTId',
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
      'L_Id': selectedLId,
      'T_Id': selectedTId,
    };

    await dbRef.child('$newPid').set(newPool);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pool "$poolName" added successfully')),
    );

    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
          children: [
            const Text(
              'Add New Pool',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.thirtary,
              ),
            ),
            const SizedBox(height: 20),

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
                  selectedLId =
                      lewayaList.firstWhere((e) => e['name'] == val)['L_ID'];
                  fetchTypes(selectedLId!);
                });
              },
              decoration: _inputDecoration('Select Lewaya'),
              dropdownColor: AppColors.secondary,
              style: const TextStyle(color: AppColors.thirtary),
            ),

            const SizedBox(height: 16),

            // Type Dropdown
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
                });
              },
              decoration: _inputDecoration('Select Type'),
              dropdownColor: AppColors.secondary,
              style: const TextStyle(color: AppColors.thirtary),
            ),

            const SizedBox(height: 16),

            // Pool name field
            TextField(
              controller: _poolController,
              decoration: _inputDecoration('Pool Name or Number'),
              style: const TextStyle(color: AppColors.thirtary),
            ),

            const SizedBox(height: 24),

            // Add Pool button
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: _addPool,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.thirtary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                ),
                child: const Text(
                  'Add Pool',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Cancel Button
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
}
