import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:myapp/AppColors.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;
import 'package:myapp/reusable_components/profile_drawer.dart';

class AnalyseSection extends StatefulWidget {
  @override
  _AnalyzeScreenState createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyseSection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedLewaya;
  List<String> lewayaList = [];
  Map<String, List<Map<String, dynamic>>> rainfallMap = {};
  List<Map<String, dynamic>> pt01Data = [];
  List<Map<String, dynamic>> dc06Data = [];
  List<FlSpot> chartData = [];
  List<FlSpot> secondaryChartData = [];
  List<BarChartGroupData> barData = [];
  List<BarChartGroupData> secondaryBarData = [];
  List<String> dateLabels = [];

  String selectedFilter = 'Day';

  @override
  void initState() {
    super.initState();
    fetchLewayaAndData();
  }

  Future<void> fetchLewayaAndData() async {
    final db = FirebaseDatabase.instance.ref();
    final rainfallSnap = await db.child('rainfall').get();
    final readingSnap = await db.child('Reading_Details/1/1').get();

    if (rainfallSnap.exists) {
      final rainfall = rainfallSnap.value as Map;
      rainfall.forEach((lewaya, record) {
        lewayaList.add(lewaya);
        List<Map<String, dynamic>> list = [];
        (record as Map).forEach((date, value) {
          list.add({
            'date': date.toString(),
            'value': double.tryParse(value.toString()) ?? 0.0,
          });
        });
        list.sort((a, b) => a['date'].compareTo(b['date']));
        rainfallMap[lewaya] = list;
      });
    }

    if (readingSnap.exists) {
      final readingData = (readingSnap.value as Map).values;
      pt01Data.clear();
      dc06Data.clear();

      for (var entry in readingData) {
        if (entry is Map) {
          String? pName = entry['P_Name'];
          String? date = entry['Date'];
          double? uDensity = double.tryParse(
            entry['U_Density(Kgm-3)'].toString(),
          );

          if (pName == "PT01" && date != null) {
            pt01Data.add({'date': date, 'value': uDensity ?? 0});
          } else if (pName == "DC06" && date != null) {
            dc06Data.add({'date': date, 'value': uDensity ?? 0});
          }
        }
      }

      pt01Data.sort((a, b) => a['date'].compareTo(b['date']));
      dc06Data.sort((a, b) => a['date'].compareTo(b['date']));
    }

    if (lewayaList.isNotEmpty) {
      selectedLewaya = lewayaList.first;
      updateChartData();
    }
  }

  void updateChartData() {
    final data = rainfallMap[selectedLewaya];
    if (data == null) return;

    chartData.clear();
    barData.clear();
    secondaryChartData.clear();
    secondaryBarData.clear();
    dateLabels.clear();

    DateTime now = DateTime.now();

    List<Map<String, dynamic>> filteredData =
        data.where((entry) {
          DateTime entryDate =
              DateTime.tryParse(entry['date']) ?? DateTime(2000);
          switch (selectedFilter) {
            case 'Day':
              return _isSameDay(entryDate, now);
            case 'Month':
              return entryDate.year == now.year && entryDate.month == now.month;
            case 'Year':
              return entryDate.year == now.year;
            case 'All':
            default:
              return true;
          }
        }).toList();

    for (int i = 0; i < filteredData.length; i++) {
      double value = filteredData[i]['value'];
      chartData.add(FlSpot(i.toDouble(), value));
      barData.add(
        BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(toY: value, color: blueColor1)],
        ),
      );
      dateLabels.add(filteredData[i]['date']);
    }

    List<Map<String, dynamic>> overlayData = [];
    if (selectedLewaya == 'Mahalewaya') {
      overlayData = pt01Data;
    } else if (selectedLewaya == 'Koholankala') {
      overlayData = dc06Data;
    }

    List<Map<String, dynamic>> filteredOverlay =
        overlayData.where((entry) {
          DateTime entryDate =
              DateTime.tryParse(entry['date']) ?? DateTime(2000);
          switch (selectedFilter) {
            case 'Day':
              return _isSameDay(entryDate, now);
            case 'Month':
              return entryDate.year == now.year && entryDate.month == now.month;
            case 'Year':
              return entryDate.year == now.year;
            case 'All':
            default:
              return true;
          }
        }).toList();

    for (int i = 0; i < filteredOverlay.length; i++) {
      double value = filteredOverlay[i]['value'];
      secondaryChartData.add(FlSpot(i.toDouble(), value));
      secondaryBarData.add(
        BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(toY: value, color: blueColor2)],
        ),
      );
    }

    setState(() {});
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index >= 0 && index < dateLabels.length) {
      return Text(
        DateFormat('MM-dd').format(DateTime.parse(dateLabels[index])),
        style: smallTextStyle,
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ProfileDrawer(),
      appBar: AppBar(
        shadowColor: blackColor,
        elevation: 2,
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        backgroundColor: greyColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  backgroundImage: AssetImage("assets/salt.png"),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Rainfall Analyze Details", style: headingTextStyle),
                SizedBox(height: 30),

                Text("Please Select the Lewaya", style: smallTextStyle),
                SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: selectedLewaya,
                  items:
                      lewayaList.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child:
                          // Text(item, style: smallTextStyle),
                          Row(
                            children: [
                              Icon(Icons.my_location_rounded),
                              SizedBox(width: 15),
                              Text(item, style: smallTextStyle),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (val) {
                    selectedLewaya = val;
                    updateChartData();
                  },
                  decoration: InputDecoration(
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
                    // labelText: 'Select Current Name',
                    // labelStyle: smallTextStyle,
                    // hint: Row(
                    //   children: [
                    //     Icon(Icons.my_location_rounded),
                    //     SizedBox(width: 15),
                    //     Text("Select", style: smallTextStyle),
                    //   ],
                    // ),
                  ),
                  dropdownColor: greyColor,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      ['Day', 'Month', 'Year', 'All'].map((filter) {
                        return Row(
                          children: [
                            Radio<String>(
                              value: filter,
                              groupValue: selectedFilter,
                              onChanged: (val) {
                                setState(() {
                                  selectedFilter = val!;
                                  updateChartData();
                                });
                              },
                              fillColor: MaterialStateProperty.all(blackColor),
                            ),
                            Text(filter, style: smallTextStyle),
                          ],
                        );
                      }).toList(),
                ),
                SizedBox(height: 20),
                Expanded(
                  child:
                      chartData.isEmpty
                          ? Center(
                            child: Text("No data", style: smallTextStyle),
                          )
                          : (selectedFilter == 'Day' ||
                              selectedFilter == 'Month')
                          ? BarChart(
                            BarChartData(
                              gridData: FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: _bottomTitleWidgets,
                                  ),
                                ),
                              ),
                              barGroups: List.generate(chartData.length, (i) {
                                List<BarChartRodData> rods = [];
                                rods.add(
                                  BarChartRodData(
                                    toY: chartData[i].y,
                                    color: blueColor1,
                                    width: 10,
                                  ),
                                );
                                if (i < secondaryBarData.length) {
                                  rods.add(
                                    BarChartRodData(
                                      toY: secondaryChartData[i].y,
                                      color: blueColor2,
                                      width: 10,
                                    ),
                                  );
                                }
                                return BarChartGroupData(x: i, barRods: rods);
                              }),
                            ),
                          )
                          : LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: _bottomTitleWidgets,
                                  ),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: chartData,
                                  isCurved: true,
                                  color: blueColor1,
                                  dotData: FlDotData(show: true),
                                ),
                                if (secondaryChartData.isNotEmpty)
                                  LineChartBarData(
                                    spots: secondaryChartData,
                                    isCurved: true,
                                    color: blueColor2,
                                    dotData: FlDotData(show: true),
                                  ),
                              ],
                            ),
                          ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
