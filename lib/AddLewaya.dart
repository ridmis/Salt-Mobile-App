import 'package:flutter/material.dart';
import 'package:myapp/AppColors.dart';
import 'package:firebase_database/firebase_database.dart';

void showAddLewayaDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => const Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: AddLewayaForm(),
        ),
  );
}

class AddLewayaForm extends StatefulWidget {
  const AddLewayaForm({super.key});

  @override
  State<AddLewayaForm> createState() => _AddLewayaFormState();
}

class _AddLewayaFormState extends State<AddLewayaForm> {
  final TextEditingController _lewayaController = TextEditingController();

  void _addLewaya() async {
    String lewayaName = _lewayaController.text.trim();

    if (lewayaName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Lewaya name')),
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Lewaya "$lewayaName" added')));

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add New Lewaya',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.thirtary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _lewayaController,
            style: const TextStyle(color: AppColors.thirtary),
            decoration: InputDecoration(
              labelText: 'Lewaya Name',
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

          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: _addLewaya,
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
                'Add Lewaya',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
