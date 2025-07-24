import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;
import 'package:myapp/reusable_components/large_elevated_button.dart';
import 'package:myapp/reusable_components/profile_drawer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'web_helper.dart'
    if (dart.library.io) 'mobile_helper.dart'
    as file_helper;

class ReportSection extends StatefulWidget {
  @override
  _ReportSectionState createState() => _ReportSectionState();
}

class _ReportSectionState extends State<ReportSection> {
  String selected = 'Rainfall';
  String? selectedLewaya;
  DateTime? startDate;
  DateTime? endDate;
  List<Map<String, dynamic>> tableData = [];
  List<String> lewayaList = [];
  bool isLoading = false;
  Map<int, String> lewayaIdToName = {};
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    fetchLewayaNames();
  }

  Future<void> fetchLewayaNames() async {
    final ref = FirebaseDatabase.instance.ref().child('Lewaya');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      List<String> tempLewayaList = [];
      Map<int, String> tempMap = {};
      data.forEach((key, value) {
        int id = value['L_ID'];
        String name = value['name'];
        tempMap[id] = name;
        tempLewayaList.add(name);
      });
      setState(() {
        lewayaIdToName = tempMap;
        lewayaList = tempLewayaList;
      });
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      tableData.clear();
    });

    if (selected == 'Rainfall') {
      final dbRef = FirebaseDatabase.instance.ref().child('rainfall');
      final snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;
        List<Map<String, dynamic>> temp = [];

        data.forEach((lewaya, records) {
          if (records is Map) {
            if (selectedLewaya != null && selectedLewaya != lewaya.toString())
              return;

            records.forEach((date, value) {
              DateTime currentDate =
                  DateTime.tryParse(date.toString()) ?? DateTime(1900);
              if (startDate != null && currentDate.isBefore(startDate!)) return;
              if (endDate != null && currentDate.isAfter(endDate!)) return;

              temp.add({
                'date': date.toString(),
                'lewaya': lewaya.toString(),
                'value': value.toString(),
              });
            });
          }
        });

        temp.sort((a, b) => b['date'].compareTo(a['date']));

        setState(() {
          tableData = temp;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } else if (selected == 'Density Readings') {
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
                    String lewayaName = lewayaIdToName[lId] ?? 'Unknown';

                    if (selectedLewaya != null && selectedLewaya != lewayaName)
                      return;

                    DateTime currentDate =
                        DateTime.tryParse(value['Date'].toString()) ??
                        DateTime(1900);
                    if (startDate != null && currentDate.isBefore(startDate!))
                      return;
                    if (endDate != null && currentDate.isAfter(endDate!))
                      return;

                    temp.add({
                      'date': value['Date'] ?? '',
                      'lewaya': lewayaName,
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

        temp.sort((a, b) => b['date'].compareTo(a['date']));

        setState(() {
          tableData = temp;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> exportToCSV() async {
    if (tableData.isEmpty) return;

    List<List<dynamic>> rows = [];

    if (selected == 'Rainfall') {
      rows.add(['Date', 'Lewaya Name', 'Value']);
      rows.addAll(
        tableData.map((item) => [item['date'], item['lewaya'], item['value']]),
      );
    } else {
      rows.add([
        'Date',
        'Lewaya Name',
        'Pool',
        'Upper Density',
        'Lower Density',
        'Depth',
      ]);
      rows.addAll(
        tableData.map(
          (item) => [
            item['date'],
            item['lewaya'],
            item['pool'],
            item['upper'],
            item['lower'],
            item['depth'],
          ],
        ),
      );
    }

    String csvData = const ListToCsvConverter().convert(rows);

    if (kIsWeb) {
      final bytes = utf8.encode(csvData);
      file_helper.downloadFile(
        bytes,
        'report_export_${DateTime.now().millisecondsSinceEpoch}.csv',
        'text/csv',
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CSV download started')));
    } else {
      // final bytes = utf8.encode(csvData);
      // final path = await file_helper.saveFileToDevice(
      //   bytes,
      //   'report_export_${DateTime.now().millisecondsSinceEpoch}.csv',
      // );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('CSV exported to: $path'),
      //     backgroundColor: Colors.green,
      //   ),
      // );
    }
  }

  Future<void> exportToPDF() async {
    if (tableData.isEmpty) return;

    final pdf = pw.Document();

    List<String> headers;
    List<List<String>> dataRows = [];

    if (selected == 'Rainfall') {
      headers = ['Date', 'Lewaya Name', 'Value'];
      for (var item in tableData) {
        dataRows.add([item['date'], item['lewaya'], item['value'].toString()]);
      }
    } else {
      headers = [
        'Date',
        'Lewaya Name',
        'Pool',
        'Upper Density',
        'Lower Density',
        'Depth',
      ];
      for (var item in tableData) {
        dataRows.add([
          item['date'],
          item['lewaya'],
          item['pool'],
          item['upper'],
          item['lower'],
          item['depth'],
        ]);
      }
    }

    String filterDesc =
        'Report Type: $selected\n'
        'Lewaya: ${selectedLewaya ?? 'All'}\n'
        'Date Range: ${startDate != null ? formatter.format(startDate!) : 'Start'} - ${endDate != null ? formatter.format(endDate!) : 'End'}\n';

    String exportTime = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              pw.Text(
                'Report Export',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(filterDesc, style: pw.TextStyle(fontSize: 12)),
              pw.Divider(),
              pw.Table.fromTextArray(
                headers: headers,
                data: dataRows,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: const pw.EdgeInsets.all(5),
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Exported on: $exportTime',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                ),
              ),
            ],
      ),
    );

    if (kIsWeb) {
      final bytes = await pdf.save();
      file_helper.downloadFile(
        bytes,
        'report_export_${DateTime.now().millisecondsSinceEpoch}.pdf',
        'application/pdf',
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('PDF download started')));
    } else {
      // final bytes = await pdf.save();
      // final path = await file_helper.saveFileToDevice(
      //   bytes,
      //   'report_export_${DateTime.now().millisecondsSinceEpoch}.pdf',
      // );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('PDF exported to: $path'),
      //     backgroundColor: Colors.green,
      //   ),
      // );
    }
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => startDate = picked);
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => endDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Report Section'),
      //   centerTitle: true,
      //   backgroundColor: AppColors.primary,
      //   foregroundColor: AppColors.thirtary, // title + icons in white
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.file_download),
      //       tooltip: 'Export to CSV',
      //       onPressed: tableData.isNotEmpty ? exportToCSV : null,
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.picture_as_pdf),
      //       tooltip: 'Export to PDF',
      //       onPressed: tableData.isNotEmpty ? exportToPDF : null,
      //     ),
      //   ],
      // ),
      key: _scaffoldKey,
      drawer: ProfileDrawer(),
      appBar: AppBar(
        shadowColor: blackColor,
        elevation: 2,
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        backgroundColor: greyColor,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${global.userName}",
                            style: headingTextStyle.copyWith(fontSize: 20),
                          ),
                          Text(global.userType, style: smallTextStyle),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: CircleAvatar(
                  backgroundColor: whiteColor,
                  radius: MediaQuery.of(context).size.width * 0.06,
                  backgroundImage: AssetImage("assets/Sample_User_Icon.png"),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Report", style: headingTextStyle),
              SizedBox(height: 30),
              Text("Please Select report Type", style: smallTextStyle),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                hint: Row(
                  children: [
                    Icon(Icons.location_searching_rounded),
                    SizedBox(width: 15),
                    Text("Select", style: smallTextStyle),
                  ],
                ),
                value: selected,
                items:
                    ['Rainfall', 'Density Readings']
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Row(
                              children: [
                                Icon(Icons.manage_search_outlined),
                                SizedBox(width: 15),
                                Text(item, style: smallTextStyle),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  setState(() {
                    selected = val!;
                    selectedLewaya = null;
                    tableData.clear();
                  });
                },
                dropdownColor: greyColor,
                style: smallTextStyle,
                decoration: _inputDecoration(''),
              ),
              // DropdownButtonFormField<String>(
              //   value: selected,
              //   dropdownColor: AppColors.thirtary,
              //   style: dropdownTextStyle,
              //   iconEnabledColor: AppColors.thirtary,
              //   iconDisabledColor: AppColors.thirtary,
              //   decoration: InputDecoration(
              //     labelText: 'Select Report Type',
              //     labelStyle: labelTextStyle,
              //     border: const OutlineInputBorder(),
              //     enabledBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(color: AppColors.thirtary),
              //     ),
              //     focusedBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(color: AppColors.secondary),
              //     ),
              //   ),
              //   items:
              //       ['Rainfall', 'Density Readings']
              //           .map(
              //             (item) => DropdownMenuItem(
              //               value: item,
              //               child: Text(
              //                 item,
              //                 style: const TextStyle(color: Colors.black),
              //               ),
              //             ),
              //           )
              //           .toList(),
              //   onChanged: (val) {
              //     setState(() {
              //       selected = val!;
              //       selectedLewaya = null;
              //       tableData.clear();
              //     });
              //   },
              // ),
              const SizedBox(height: 20),
              Text("Filter by Lewaya", style: smallTextStyle),
              SizedBox(height: 20),

              if (lewayaList.isNotEmpty)
                DropdownButtonFormField<String>(
                  hint: Row(
                    children: [
                      Icon(Icons.sort_rounded),
                      SizedBox(width: 15),
                      Text("All", style: smallTextStyle),
                    ],
                  ),
                  value: selectedLewaya,
                  dropdownColor: greyColor,
                  style: smallTextStyle,
                  // iconEnabledColor: AppColors.thirtary,
                  // iconDisabledColor: AppColors.thirtary,
                  // decoration: InputDecoration(
                  //   labelText: 'Filter by Lewaya',
                  //   labelStyle: smallTextStyle,
                  //   border: const OutlineInputBorder(),
                  //   enabledBorder: const OutlineInputBorder(
                  //     borderSide: BorderSide(color: AppColors.thirtary),
                  //   ),
                  //   focusedBorder: const OutlineInputBorder(
                  //     borderSide: BorderSide(color: AppColors.secondary),
                  //   ),
                  // ),
                  decoration: _inputDecoration(""),
                  items:
                      lewayaList
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item, style: smallTextStyle),
                            ),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => selectedLewaya = val),
                ),

              SizedBox(height: 20),
              Text("Time Period", style: smallTextStyle),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: greyColor,
                      ),
                      onPressed: () => _pickStartDate(context),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, color: blackColor),
                          SizedBox(width: 10),
                          Text(
                            textAlign: TextAlign.center,
                            startDate == null
                                ? "Start Date"
                                : "${formatter.format(startDate!)}",
                            style: smallTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: greyColor,
                      ),
                      onPressed: () => _pickEndDate(context),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, color: blackColor),
                          SizedBox(width: 10),
                          Text(
                            textAlign: TextAlign.center,
                            endDate == null
                                ? "End Date"
                                : "${formatter.format(endDate!)}",
                            style: smallTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              LargeElevatedButton(title: "Search", onPressed: fetchData),

              // Row(
              //   children: [
              //     Expanded(
              //       child: OutlinedButton(
              //         style: OutlinedButton.styleFrom(
              //           side: const BorderSide(color: AppColors.thirtary),
              //         ),
              //         onPressed: () => _pickStartDate(context),
              //         child: Text(
              //           startDate == null
              //               ? "Start Date"
              //               : "Start: ${formatter.format(startDate!)}",
              //           style: labelTextStyle,
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: OutlinedButton(
              //         style: OutlinedButton.styleFrom(
              //           side: const BorderSide(color: AppColors.thirtary),
              //         ),
              //         onPressed: () => _pickEndDate(context),
              //         child: Text(
              //           endDate == null
              //               ? "End Date"
              //               : "End: ${formatter.format(endDate!)}",
              //           style: labelTextStyle,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              Divider(),

              // Align(
              //   alignment: Alignment.centerRight,
              //   child: ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.secondary,
              //       foregroundColor: AppColors.thirtary,
              //     ),
              //     onPressed: fetchData,
              //     icon: const Icon(Icons.search),
              //     label: const Text("Search"),
              //   ),
              // ),

              // const SizedBox(height: 20),
              // Expanded(
              //   child:
              //       tableData.isEmpty
              //           ? Center(
              //             child: Text(
              //               "No data to display",
              //               style: smallTextStyle,
              //             ),
              //           )
              //           : Scrollbar(
              //             thumbVisibility: true,
              //             trackVisibility: true,
              //             child: SingleChildScrollView(
              //               scrollDirection: Axis.horizontal,
              //               child: SingleChildScrollView(

              //                 scrollDirection: Axis.vertical,

              //                 child: DataTable(
              //                   columnSpacing: 24,
              //                   headingRowColor: MaterialStateProperty.all(
              //                     AppColors.secondary.withOpacity(0.3),
              //                   ),
              //                   dataRowColor: MaterialStateProperty.all(
              //                     AppColors.primary.withOpacity(0.2),
              //                   ),
              //                   headingTextStyle: const TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     color: Colors.black,
              //                   ),
              //                   dataTextStyle: const TextStyle(
              //                     color: Colors.black,
              //                   ),
              //                   columns:
              //                       selected == 'Rainfall'
              //                           ? const [
              //                             DataColumn(label: Text('Date')),
              //                             DataColumn(
              //                               label: Text('Lewaya Name'),
              //                             ),
              //                             DataColumn(label: Text('Value')),
              //                           ]
              //                           : const [
              //                             DataColumn(label: Text('Date')),
              //                             DataColumn(
              //                               label: Text('Lewaya Name'),
              //                             ),
              //                             DataColumn(label: Text('Pool')),
              //                             DataColumn(
              //                               label: Text('Upper Density'),
              //                             ),
              //                             DataColumn(
              //                               label: Text('Lower Density'),
              //                             ),
              //                             DataColumn(label: Text('Depth')),
              //                           ],
              //                   rows:
              //                       tableData.map((row) {
              //                         return DataRow(
              //                           cells:
              //                               selected == 'Rainfall'
              //                                   ? [
              //                                     DataCell(Text(row['date'])),
              //                                     DataCell(Text(row['lewaya'])),
              //                                     DataCell(Text(row['value'])),
              //                                   ]
              //                                   : [
              //                                     DataCell(Text(row['date'])),
              //                                     DataCell(Text(row['lewaya'])),
              //                                     DataCell(Text(row['pool'])),
              //                                     DataCell(Text(row['upper'])),
              //                                     DataCell(Text(row['lower'])),
              //                                     DataCell(Text(row['depth'])),
              //                                   ],
              //                         );
              //                       }).toList(),
              //                 ),
              //               ),
              //             ),
              //           ),
              // ),
              SizedBox(
                height: tableData.length.toDouble() * 50 + 100,
                child:
                    tableData.isEmpty
                        ? Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            textAlign: TextAlign.center,
                            "No data to display",
                            style: smallTextStyle,
                          ),
                        )
                        : LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Download Report",
                                      style: smallTextStyle,
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "As CSV",
                                              style: tableDataTextStyle,
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.file_download,
                                              ),
                                              tooltip: 'Export to CSV',
                                              onPressed:
                                                  tableData.isNotEmpty
                                                      ? exportToCSV
                                                      : null,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "As PDF",
                                              style: tableDataTextStyle,
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.picture_as_pdf,
                                              ),
                                              tooltip: 'Export to PDF',
                                              onPressed:
                                                  tableData.isNotEmpty
                                                      ? exportToPDF
                                                      : null,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Container(
                                      // width:
                                      // MediaQuery.of(context).size.width * 1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAlias,

                                      child: DataTable(
                                        dataRowHeight: 45,
                                        showCheckboxColumn: false,
                                        dividerThickness: 1,
                                        border: TableBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),

                                          horizontalInside: BorderSide(
                                            color: blackColor,
                                            width: 1,
                                          ),
                                        ),

                                        // showBottomBorder: true,
                                        columnSpacing:
                                            MediaQuery.of(context).size.width *
                                            .08,
                                        headingRowColor:
                                            MaterialStateProperty.all(
                                              blueColor2.withOpacity(.4),
                                            ),
                                        dataRowColor: MaterialStateProperty.all(
                                          greyColor,
                                        ),
                                        headingTextStyle: smallTextStyle
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                        dataTextStyle: tableDataTextStyle,
                                        columns:
                                            selected == 'Rainfall'
                                                ? const [
                                                  DataColumn(
                                                    label: Text('Date'),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Lewaya Name'),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Value'),
                                                  ),
                                                ]
                                                : const [
                                                  DataColumn(
                                                    label: Text('Date'),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Lewaya Name'),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Pool'),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Upper Density',
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Lower Density',
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Depth'),
                                                  ),
                                                ],
                                        rows:
                                            tableData.map((row) {
                                              return DataRow(
                                                cells:
                                                    selected == 'Rainfall'
                                                        ? [
                                                          DataCell(
                                                            Text(row['date']),
                                                          ),
                                                          DataCell(
                                                            Text(row['lewaya']),
                                                          ),
                                                          DataCell(
                                                            Text(
                                                              "${row['value']} mm",
                                                            ),
                                                          ),
                                                        ]
                                                        : [
                                                          DataCell(
                                                            Text(row['date']),
                                                          ),
                                                          DataCell(
                                                            Text(row['lewaya']),
                                                          ),
                                                          DataCell(
                                                            Text(row['pool']),
                                                          ),
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
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String label) => InputDecoration(
  labelText: label,
  labelStyle: smallTextStyle,
  filled: true,
  fillColor: greyColor,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  ),
);
