import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';
import 'package:myapp/global.dart' as global;

class SelectTypeScreen extends StatefulWidget {
  const SelectTypeScreen({super.key});

  @override
  State<SelectTypeScreen> createState() => _SelectTypeScreenState();
}

class _SelectTypeScreenState extends State<SelectTypeScreen> {
  List<Map<String, dynamic>> typesList = [];

  @override
  void initState() {
    super.initState();
    selectType();
  }

  void selectType() async {
    int selectedLId = global.selectedLId;
    final dbRef = FirebaseDatabase.instance.ref().child('Types/$selectedLId');
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value;
      List<Map<String, dynamic>> tempList = [];

      if (data is List) {
        for (var item in data) {
          if (item != null && item is Map && item['Type_Name'] != null) {
            tempList.add({'name': item['Type_Name'], 'T_Id': item['T_Id']});
            print(item['Type_Name']);
          }
        }
      } else if (data is Map) {
        data.forEach((key, value) {
          if (value != null && value['Type_Name'] != null) {
            tempList.add({'name': value['Type_Name'], 'T_Id': value['T_Id']});
            print(value['Type_Name']);
          }
        });
      }

      setState(() {
        typesList = tempList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select the type',
          style: TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Dynamically create buttons from typesList
                  ...typesList.map(
                    (type) => Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: _buildTypeButton(
                        context,
                        type['name'],
                        onPressed: () {
                          global.SelectedTypeId = type['T_Id'];
                          global.selectedTypeName = type['name'];

                          print(global.SelectedTypeId);
                          Navigator.pushNamed(context, '/polls');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildTypeButton(
  BuildContext context,
  String label, {
  required VoidCallback onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: AppColors.thirtary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
          ),
          Image.asset('assets/bubble.jpg', height: 40, width: 40),
        ],
      ),
    ),
  );
}
