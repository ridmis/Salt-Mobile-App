// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:myapp/AppColors.dart';

// void showAddPoolDialog(BuildContext context) {
//   // Create local state variables for the dialog
//   List<Map<String, dynamic>> localLewayaList = [];
//   List<Map<String, dynamic>> localTypeList = [];
//   String? localSelectedLewayaName;
//   int? localSelectedLewayaId;
//   String? localSelectedTypeName;
//   int? localSelectedTypeId;
//   final TextEditingController localPoolController = TextEditingController();

//   // Fetch Lewayas
//   void fetchLocalLewayas(StateSetter setState) async {
//     final dbRef = FirebaseDatabase.instance.ref().child('Lewaya');
//     final snapshot = await dbRef.get();

//     if (snapshot.exists) {
//       final data = snapshot.value as Map;
//       List<Map<String, dynamic>> tempList = [];
//       data.forEach((key, value) {
//         tempList.add({'name': value['name'], 'L_ID': value['L_ID']});
//       });

//       setState(() {
//         localLewayaList = tempList;
//       });
//     }
//   }

//   // Fetch Types
//   void fetchLocalTypes(int lewayaId, StateSetter setState) async {
//     // Clear types first
//     setState(() {
//       localTypeList = [];
//       localSelectedTypeName = null;
//       localSelectedTypeId = null;
//     });

//     // Fetch new types
//     final dbRef = FirebaseDatabase.instance.ref().child('Types/$lewayaId');
//     final snapshot = await dbRef.get();

//     List<Map<String, dynamic>> temp = [];
//     if (snapshot.exists) {
//       final data = snapshot.value;
//       if (data is List) {
//         for (var item in data) {
//           if (item != null &&
//               item['T_Id'] != null &&
//               item['Type_Name'] != null) {
//             temp.add({'T_Id': item['T_Id'], 'Type_Name': item['Type_Name']});
//           }
//         }
//       }
//     }

//     // Update the local type list
//     setState(() {
//       localTypeList = temp;
//     });
//   }

//   // Add Pool function
//   void addLocalPool(BuildContext context) async {
//     final poolName = localPoolController.text.trim();

//     if (localSelectedLewayaId == null ||
//         localSelectedTypeId == null ||
//         poolName.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select Lewaya, Type, and enter Pool name'),
//         ),
//       );
//       return;
//     }

//     final dbRef = FirebaseDatabase.instance.ref().child(
//       'Pools/$localSelectedLewayaId/$localSelectedTypeId',
//     );
//     final snapshot = await dbRef.get();

//     int newPid = 1;
//     if (snapshot.exists && snapshot.value is List) {
//       List poolList = snapshot.value as List;
//       newPid = poolList.where((e) => e != null).length + 1;
//     }

//     final newPool = {
//       'P_Id': newPid,
//       'P_Name': poolName,
//       'L_Id': localSelectedLewayaId,
//       'T_Id': localSelectedTypeId,
//     };

//     await dbRef.child('$newPid').set(newPool);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Pool "$poolName" added successfully')),
//     );

//     Navigator.pop(context);
//   }

//   // Input decoration function
//   InputDecoration localInputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: AppColors.thirtary),
//       enabledBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: AppColors.thirtary),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: AppColors.thirtary, width: 2),
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           // Fetch Lewayas when dialog is first shown
//           if (localLewayaList.isEmpty) {
//             fetchLocalLewayas(setState);
//           }

//           return Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Container(
//               padding: const EdgeInsets.all(24),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [AppColors.primary, AppColors.secondary],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//                 borderRadius: BorderRadius.all(Radius.circular(16)),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       'Add New Pool',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.thirtary,
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // Lewaya Dropdown
//                     DropdownButtonFormField<String>(
//                       value: localSelectedLewayaName,
//                       items:
//                           localLewayaList.map((item) {
//                             return DropdownMenuItem<String>(
//                               value: item['name'],
//                               child: Text(item['name']),
//                             );
//                           }).toList(),
//                       onChanged: (val) {
//                         setState(() {
//                           localSelectedLewayaName = val;
//                           localSelectedLewayaId =
//                               localLewayaList.firstWhere(
//                                 (e) => e['name'] == val,
//                               )['L_ID'];
//                         });

//                         // Fetch types
//                         fetchLocalTypes(localSelectedLewayaId!, setState);
//                       },
//                       decoration: localInputDecoration('Select Lewaya'),
//                       dropdownColor: AppColors.secondary,
//                       style: const TextStyle(color: AppColors.thirtary),
//                     ),

//                     const SizedBox(height: 16),

//                     // Type Dropdown
//                     DropdownButtonFormField<String>(
//                       key: ValueKey(localSelectedLewayaId),
//                       value: localSelectedTypeName,
//                       items:
//                           localTypeList.isEmpty
//                               ? [] // Empty list when no types available
//                               : localTypeList.map((item) {
//                                 return DropdownMenuItem<String>(
//                                   value: item['Type_Name'],
//                                   child: Text(item['Type_Name']),
//                                 );
//                               }).toList(),
//                       onChanged:
//                           localTypeList.isEmpty
//                               ? null
//                               : (val) {
//                                 setState(() {
//                                   localSelectedTypeName = val;
//                                   localSelectedTypeId =
//                                       localTypeList.firstWhere(
//                                         (e) => e['Type_Name'] == val,
//                                       )['T_Id'];
//                                 });
//                               },
//                       decoration: localInputDecoration('Select Type'),
//                       dropdownColor: AppColors.secondary,
//                       style: const TextStyle(color: AppColors.thirtary),
//                       disabledHint: Text(
//                         'Select Lewaya first',
//                         style: TextStyle(
//                           color: AppColors.thirtary.withOpacity(0.5),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Pool name field
//                     TextField(
//                       controller: localPoolController,
//                       decoration: localInputDecoration('Pool Name or Number'),
//                       style: const TextStyle(color: AppColors.thirtary),
//                     ),

//                     const SizedBox(height: 24),

//                     // Add Pool button
//                     SizedBox(
//                       width: 160,
//                       child: ElevatedButton(
//                         onPressed: () => addLocalPool(context),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.secondary,
//                           foregroundColor: AppColors.thirtary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 6,
//                         ),
//                         child: const Text(
//                           'Add Pool',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),

//                     // Cancel Button
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text(
//                         'Cancel',
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }

// class AddPoolForm extends StatefulWidget {
//   const AddPoolForm({super.key});

//   @override
//   State<AddPoolForm> createState() => _AddPoolFormState();
// }

// class _AddPoolFormState extends State<AddPoolForm> {
//   final TextEditingController _poolController = TextEditingController();

//   List<Map<String, dynamic>> lewayaListforPool = [];
//   List<Map<String, dynamic>> typeList = [];

//   String? selectedLewayaNameforPool;
//   int? selectedLIdforPool;

//   String? selectedTypeName;
//   int? selectedTId;

//   @override
//   void initState() {
//     super.initState();
//     fetchLewayasforPool();
//   }

//   void fetchLewayasforPool() async {
//     final dbRef = FirebaseDatabase.instance.ref().child('Lewaya');
//     final snapshot = await dbRef.get();

//     if (snapshot.exists) {
//       final data = snapshot.value as Map;
//       List<Map<String, dynamic>> tempList = [];
//       data.forEach((key, value) {
//         tempList.add({'name': value['name'], 'L_ID': value['L_ID']});
//       });

//       setState(() {
//         lewayaListforPool = tempList;
//       });
//     }
//   }

//   void fetchTypes(int lewayaId) async {
//     // First clear everything to ensure UI updates
//     setState(() {
//       typeList = []; // Clear the list first
//       selectedTypeName = null;
//       selectedTId = null;
//     });

//     // Add a small delay to ensure the UI updates before fetching new data
//     await Future.delayed(Duration(milliseconds: 100));

//     // Then fetch new data
//     final dbRef = FirebaseDatabase.instance.ref().child('Types/$lewayaId');
//     final snapshot = await dbRef.get();

//     List<Map<String, dynamic>> temp = [];
//     if (snapshot.exists) {
//       final data = snapshot.value;
//       if (data is List) {
//         for (var item in data) {
//           if (item != null &&
//               item['T_Id'] != null &&
//               item['Type_Name'] != null) {
//             temp.add({'T_Id': item['T_Id'], 'Type_Name': item['Type_Name']});
//           }
//         }
//       }
//     }

//     // Force rebuild with the new data
//     if (mounted) {
//       setState(() {
//         typeList = temp;
//       });
//     }
//   }

//   void _addPool() async {
//     final poolName = _poolController.text.trim();

//     if (selectedLIdforPool == null || selectedTId == null || poolName.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select Lewaya, Type, and enter Pool name'),
//         ),
//       );
//       return;
//     }

//     final dbRef = FirebaseDatabase.instance.ref().child(
//       'Pools/$selectedLIdforPool/$selectedTId',
//     );
//     final snapshot = await dbRef.get();

//     int newPid = 1;
//     if (snapshot.exists && snapshot.value is List) {
//       List poolList = snapshot.value as List;
//       newPid = poolList.where((e) => e != null).length + 1;
//     }

//     final newPool = {
//       'P_Id': newPid,
//       'P_Name': poolName,
//       'L_Id': selectedLIdforPool,
//       'T_Id': selectedTId,
//     };

//     await dbRef.child('$newPid').set(newPool);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Pool "$poolName" added successfully')),
//     );

//     Navigator.pop(context);
//   }

//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: AppColors.thirtary),
//       enabledBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: AppColors.thirtary),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: AppColors.thirtary, width: 2),
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned(
//           bottom: 0,
//           child: Container(
//             height: 200,
//             padding: const EdgeInsets.all(24),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppColors.primary, AppColors.secondary],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.all(Radius.circular(16)),
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Add New Pool',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.thirtary,
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Lewaya Dropdown
//                   DropdownButtonFormField<String>(
//                     value: selectedLewayaNameforPool,
//                     items:
//                         lewayaListforPool.map((item) {
//                           return DropdownMenuItem<String>(
//                             value: item['name'],
//                             child: Text(item['name']),
//                           );
//                         }).toList(),
//                     onChanged: (val) {
//                       // First update the selected Lewaya
//                       setState(() {
//                         selectedLewayaNameforPool = val;
//                         selectedLIdforPool =
//                             lewayaListforPool.firstWhere(
//                               (e) => e['name'] == val,
//                             )['L_ID'];
//                       });

//                       // Then fetch types outside setState
//                       fetchTypes(selectedLIdforPool!);
//                     },
//                     decoration: _inputDecoration('Select Lewaya'),
//                     dropdownColor: AppColors.secondary,
//                     style: const TextStyle(color: AppColors.thirtary),
//                   ),

//                   const SizedBox(height: 16),

//                   // Type Dropdown
//                   DropdownButtonFormField<String>(
//                     key: UniqueKey(), // Force rebuild on every build
//                     value: selectedTypeName,
//                     items:
//                         typeList.isEmpty
//                             ? [] // Empty list when no types available
//                             : typeList.map((item) {
//                               return DropdownMenuItem<String>(
//                                 value: item['Type_Name'],
//                                 child: Text(item['Type_Name']),
//                               );
//                             }).toList(),
//                     onChanged:
//                         typeList.isEmpty
//                             ? null
//                             : (val) {
//                               setState(() {
//                                 selectedTypeName = val;
//                                 selectedTId =
//                                     typeList.firstWhere(
//                                       (e) => e['Type_Name'] == val,
//                                     )['T_Id'];
//                               });
//                             },
//                     decoration: _inputDecoration('Select Type'),
//                     dropdownColor: AppColors.secondary,
//                     style: const TextStyle(color: AppColors.thirtary),
//                     disabledHint: Text(
//                       'Select Lewaya first',
//                       style: TextStyle(
//                         color: AppColors.thirtary.withOpacity(0.5),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // Pool name field
//                   TextField(
//                     controller: _poolController,
//                     decoration: _inputDecoration('Pool Name or Number'),
//                     style: const TextStyle(color: AppColors.thirtary),
//                   ),

//                   const SizedBox(height: 24),

//                   // Add Pool button
//                   SizedBox(
//                     width: 160,
//                     child: ElevatedButton(
//                       onPressed: _addPool,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.secondary,
//                         foregroundColor: AppColors.thirtary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 6,
//                       ),
//                       child: const Text(
//                         'Add Pool',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),

//                   // Cancel Button
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
