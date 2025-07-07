import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';

void showDeleteLewayaDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => const Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
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
        SnackBar(content: Text('Lewaya "$selectedLewayaName" deleted')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Lewaya to delete')),
      );
    }
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
            'Delete Lewaya',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.thirtary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

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
            dropdownColor: AppColors.secondary,
            decoration: InputDecoration(
              labelText: 'Select Lewaya',
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
            style: const TextStyle(color: AppColors.thirtary),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: deleteLewaya,
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
              'Delete Lewaya',
              style: TextStyle(fontWeight: FontWeight.bold),
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
