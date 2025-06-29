import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';

void showDeleteTypeDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
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
              'name': item['Type_Name']
            });
          }
        }
      } else if (data is Map) {
        data.forEach((key, value) {
          if (value != null && value['Type_Name'] != null) {
            tempList.add({
              'key': key,
              'name': value['Type_Name']
            });
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
        const SnackBar(content: Text('Please select Lewaya and Type to delete')),
      );
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref().child('Types/$selectedLewayaId/$selectedTypeKey');
    await dbRef.remove();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Type "$selectedTypeName" deleted')),
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
              'Delete Type',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.thirtary,
              ),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedLewayaName,
              items: lewayaList.map((item) {
                return DropdownMenuItem<String>(
                  value: item['name'],
                  child: Text(item['name']),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedLewayaName = val;
                  selectedLewayaId = lewayaList.firstWhere((e) => e['name'] == val)['L_ID'];
                  fetchTypes(selectedLewayaId!);
                });
              },
              dropdownColor: AppColors.secondary,
              style: const TextStyle(color: AppColors.thirtary),
              decoration: const InputDecoration(
                labelText: 'Select Lewaya',
                labelStyle: TextStyle(color: AppColors.thirtary),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.thirtary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.thirtary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedTypeName,
              items: typeList.map((item) {
                return DropdownMenuItem<String>(
                  value: item['name'],
                  child: Text(item['name']),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedTypeName = val;
                  selectedTypeKey = typeList.firstWhere((e) => e['name'] == val)['key'];
                });
              },
              dropdownColor: AppColors.secondary,
              style: const TextStyle(color: AppColors.thirtary),
              decoration: const InputDecoration(
                labelText: 'Select Type',
                labelStyle: TextStyle(color: AppColors.thirtary),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.thirtary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.thirtary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _deleteType,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.thirtary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                  ),
                  child: const Text('Delete'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: AppColors.thirtary)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
