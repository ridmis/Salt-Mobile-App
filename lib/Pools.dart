import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';
import 'package:myapp/global.dart' as global;

class SelectPool extends StatefulWidget {
  const SelectPool({super.key});

  @override
  State<SelectPool> createState() => _SelectPoolState();
}

class _SelectPoolState extends State<SelectPool> {
  List<Map<String, dynamic>> poolList = [];
  Set<int> washedOutPoolIds = {}; // Track submitted pools

  @override
  void initState() {
    super.initState();
    selectPool();
  }

  void selectPool() async {
    int selectedLId = global.selectedLId;
    int selectedTypeId = global.SelectedTypeId;

    final dbRef = FirebaseDatabase.instance.ref().child(
      'Pools/$selectedLId/$selectedTypeId',
    );
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value;
      List<Map<String, dynamic>> tempList = [];

      if (data is List) {
        for (var item in data) {
          if (item != null &&
              item is Map &&
              item['P_Name'] != null &&
              item['P_Id'] != null) {
            tempList.add({
              'name': item['P_Name'],
              'P_Id': int.tryParse(item['P_Id'].toString()) ?? 0,
            });
          }
        }
      } else if (data is Map) {
        data.forEach((key, value) {
          if (value != null &&
              value['P_Name'] != null &&
              value['P_Id'] != null) {
            tempList.add({
              'name': value['P_Name'],
              'P_Id': int.tryParse(value['P_Id'].toString()) ?? 0,
            });
          }
        });
      }

      setState(() {
        poolList = tempList;
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
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              'Select the number',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children:
                    poolList.map((pool) {
                      final poolId = pool['P_Id'];
                      final isWashedOut = washedOutPoolIds.contains(poolId);

                      return ElevatedButton(
                        onPressed:
                            isWashedOut
                                ? null
                                : () async {
                                  global.selectedPId = poolId;
                                  global.selectedPoolName = pool['name'];

                                  final result = await Navigator.pushNamed(
                                    context,
                                    '/mbasin',
                                    arguments: poolId.toString(),
                                  );

                                  if (result != null && result is String) {
                                    setState(() {
                                      washedOutPoolIds.add(poolId);
                                    });
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isWashedOut ? Colors.grey : AppColors.thirtary,
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        child: Text(
                          isWashedOut
                              ? '${pool['name']} (Washed Out)'
                              : pool['name'] ?? '',
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
