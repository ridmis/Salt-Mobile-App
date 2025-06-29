import 'package:flutter/material.dart';
import 'package:myapp/AppColors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/global.dart' as global;

class SelectBrineScreen extends StatefulWidget {
  const SelectBrineScreen({super.key});

  @override
  State<SelectBrineScreen> createState() => _SelectBrineScreenState();
}

class _SelectBrineScreenState extends State<SelectBrineScreen> {
  List<Map<String, dynamic>> lewayaList = [];

  @override
  void initState() {
    super.initState();
    SelectLewaya();
  }

  void SelectLewaya() async {
    final dbRef = FirebaseDatabase.instance.ref().child('Lewaya');
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      List<Map<String, dynamic>> tempList = [];

      data.forEach((key, value) {
        final id = value['L_ID'];
        final name = value['name'];
        tempList.add({'L_ID': id, 'name': name});
      });

      setState(() {
        lewayaList = tempList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'Select Lewaya',
          style: TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          //  background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    Colors.teal.shade100.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
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
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  Expanded(
                    child: ListView.builder(
                      itemCount: lewayaList.length,
                      itemBuilder: (context, index) {
                        final item = lewayaList[index];
                        return Column(
                          children: [
                            _buildTypeButton(
                              context,
                              item['name'],
                              onPressed: () {
                                global.selectedLId = item['L_ID'];
                                global.SelectedLName = item['name'];
                                Navigator.pushNamed(
                                  context,
                                  '/selecttype',
                                  arguments: item,
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
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
      height: 150,
      width: 400,
      padding: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: AppColors.thirtary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/bubble.jpg', height: 135, width: 150),
          Text(
            label,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}
