import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';

class ReadingSection extends StatefulWidget {
  @override
  _ReadingSectionState createState() => _ReadingSectionState();
}

class _ReadingSectionState extends State<ReadingSection> {
  String selected = 'Rainfall';
  List<Map<String, dynamic>> tableData = [];
  bool isLoading = false;
  Map<int, String> lewayaIdToName = {};

  @override
  void initState() {
    super.initState();
    fetchLewayaNames();
  }

  void fetchLewayaNames() async {
    final ref = FirebaseDatabase.instance.ref().child('Lewaya');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      data.forEach((key, value) {
        int id = value['L_ID'];
        String name = value['name'];
        lewayaIdToName[id] = name;
      });
    }
  }

  Future<void> fetchRainfallData() async {
    setState(() {
      isLoading = true;
      tableData.clear();
    });

    final dbRef = FirebaseDatabase.instance.ref().child('rainfall');
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      List<Map<String, dynamic>> temp = [];

      data.forEach((lewaya, records) {
        if (records is Map) {
          records.forEach((date, value) {
            temp.add({
              'date': date.toString(),
              'lewaya': lewaya.toString(),
              'value': value.toString(),
            });
          });
        }
      });

      // Sort by newest date
      temp.sort((a, b) => b['date'].compareTo(a['date']));

      setState(() {
        tableData = temp;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchReadingsData() async {
    setState(() {
      isLoading = true;
      tableData.clear();
    });

    final dbRef = FirebaseDatabase.instance.ref().child('Reading_Details');
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value;
      List<Map<String, dynamic>> temp = [];

      if (data is List) {
        for (var group in data) {
          if (group is List) {
            for (var readingGroup in group) {
              if (readingGroup is Map) {
                readingGroup.forEach((key, value) {
                  int lId = int.tryParse(value['L_Id'].toString()) ?? 0;
                  temp.add({
                    'date': value['Date'] ?? '',
                    'lewaya': lewayaIdToName[lId] ?? 'Unknown',
                    'pool': value['P_Name'] ?? '',
                    'upper': value['U_Density(Kgm-3)'].toString(),
                    'lower': value['L_Density(Kgm-3)'].toString(),
                    'depth': value['Depth'].toString(),
                  });
                });
              }
            }
          }
        }
      }

      // Sort by date descending
      temp.sort((a, b) => b['date'].compareTo(a['date']));

      setState(() {
        tableData = temp;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reading Section',
          style: TextStyle(color: AppColors.thirtary),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.thirtary),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selected,
                items:
                    ['Rainfall', 'Readings'].map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(color: AppColors.thirtary),
                        ),
                      );
                    }).toList(),
                onChanged: (val) {
                  setState(() {
                    selected = val!;
                    tableData.clear();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Type',
                  labelStyle: TextStyle(color: AppColors.thirtary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.thirtary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.thirtary),
                  ),
                ),
                dropdownColor: AppColors.primary,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
                onPressed: () {
                  if (selected == 'Rainfall') {
                    fetchRainfallData();
                  } else if (selected == 'Readings') {
                    fetchReadingsData();
                  }
                },
                child: const Text("Search"),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : Expanded(
                    child:
                        tableData.isEmpty
                            ? Center(
                              child: Text(
                                "No data to display",
                                style: TextStyle(color: AppColors.thirtary),
                              ),
                            )
                            : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  columnSpacing: 24,
                                  headingTextStyle: TextStyle(
                                    color: AppColors.thirtary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  dataTextStyle: TextStyle(
                                    color: AppColors.thirtary,
                                  ),
                                  columns:
                                      selected == 'Rainfall'
                                          ? const [
                                            DataColumn(label: Text('Date')),
                                            DataColumn(label: Text('Lewaya')),
                                            DataColumn(label: Text('Value')),
                                          ]
                                          : const [
                                            DataColumn(label: Text('Date')),
                                            DataColumn(label: Text('Lewaya')),
                                            DataColumn(label: Text('Pool')),
                                            DataColumn(label: Text('Upper')),
                                            DataColumn(label: Text('Lower')),
                                            DataColumn(label: Text('Depth')),
                                          ],
                                  rows:
                                      tableData.map((row) {
                                        return DataRow(
                                          cells:
                                              selected == 'Rainfall'
                                                  ? [
                                                    DataCell(Text(row['date'])),
                                                    DataCell(
                                                      Text(row['lewaya']),
                                                    ),
                                                    DataCell(
                                                      Text(row['value']),
                                                    ),
                                                  ]
                                                  : [
                                                    DataCell(Text(row['date'])),
                                                    DataCell(
                                                      Text(row['lewaya']),
                                                    ),
                                                    DataCell(Text(row['pool'])),
                                                    DataCell(
                                                      Text(row['upper']),
                                                    ),
                                                    DataCell(
                                                      Text(row['lower']),
                                                    ),
                                                    DataCell(
                                                      Text(row['depth']),
                                                    ),
                                                  ],
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
