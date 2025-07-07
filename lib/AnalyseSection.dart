import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:myapp/AppColors.dart';

class AnalyseSection extends StatefulWidget {
  @override
  _AnalyzeScreenState createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyseSection> {
  String? selectedLewaya;
  List<String> lewayaList = [];
  Map<String, List<Map<String, dynamic>>> rainfallMap = {};
  List<FlSpot> chartData = [];
  List<BarChartGroupData> barData = [];

  String selectedFilter = 'Day';

  @override
  void initState() {
    super.initState();
    fetchLewayaAndData();
  }

  Future<void> fetchLewayaAndData() async {
    final ref = FirebaseDatabase.instance.ref().child('rainfall');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;

      data.forEach((lewaya, records) {
        if (records is Map) {
          lewayaList.add(lewaya.toString());
          List<Map<String, dynamic>> dataList = [];

          records.forEach((date, value) {
            dataList.add({
              'date': date.toString(),
              'value': double.tryParse(value.toString()) ?? 0.0,
            });
          });

          dataList.sort((a, b) => a['date'].compareTo(b['date']));
          rainfallMap[lewaya] = dataList;
        }
      });

      setState(() {
        if (lewayaList.isNotEmpty) {
          selectedLewaya = lewayaList.first;
          updateChartData();
        }
      });
    }
  }

  void updateChartData() {
    final data = rainfallMap[selectedLewaya];
    if (data == null) return;

    chartData.clear();
    barData.clear();

    for (int i = 0; i < data.length; i++) {
      double value = data[i]['value'];
      chartData.add(FlSpot(i.toDouble(), value));
      barData.add(
        BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(toY: value, color: Colors.white)],
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Analyze Rainfall",
          style: TextStyle(color: AppColors.thirtary),
        ),
        iconTheme: IconThemeData(color: AppColors.thirtary),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedLewaya,
              items:
                  lewayaList.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          color: AppColors.thirtary,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedLewaya = val;
                  updateChartData();
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Lewaya',
                labelStyle: TextStyle(color: AppColors.thirtary),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.thirtary),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.thirtary),
                ),
              ),
              dropdownColor: AppColors.primary,
              style: TextStyle(color: AppColors.thirtary, fontSize: 13),
            ),
            const SizedBox(height: 10),

            // Radio buttons for filters
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
                            });
                          },
                          fillColor: MaterialStateProperty.all(
                            AppColors.thirtary,
                          ),
                          visualDensity: VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                        ),
                        Text(
                          filter,
                          style: TextStyle(
                            color: AppColors.thirtary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),

            const SizedBox(height: 10),

            // Graph section
            SizedBox(
              height: 250,
              child:
                  chartData.isEmpty
                      ? Center(
                        child: Text(
                          "No data to show",
                          style: TextStyle(color: AppColors.thirtary),
                        ),
                      )
                      : (selectedFilter == 'Day' || selectedFilter == 'Month')
                      ? BarChart(
                        BarChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 &&
                                      index <
                                          rainfallMap[selectedLewaya]!.length) {
                                    String dateStr =
                                        rainfallMap[selectedLewaya]![index]['date'];
                                    return Text(
                                      DateFormat(
                                        'MM-dd',
                                      ).format(DateTime.parse(dateStr)),
                                      style: TextStyle(
                                        color: AppColors.thirtary,
                                        fontSize: 10,
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                                interval: 1,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35,
                                interval: 5,
                                getTitlesWidget:
                                    (value, meta) => Text(
                                      value.toString(),
                                      style: TextStyle(
                                        color: AppColors.thirtary,
                                        fontSize: 10,
                                      ),
                                    ),
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: barData,
                        ),
                      )
                      : LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 &&
                                      index <
                                          rainfallMap[selectedLewaya]!.length) {
                                    String dateStr =
                                        rainfallMap[selectedLewaya]![index]['date'];
                                    return Text(
                                      DateFormat(
                                        'MM-dd',
                                      ).format(DateTime.parse(dateStr)),
                                      style: TextStyle(
                                        color: AppColors.thirtary,
                                        fontSize: 10,
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 35,
                                interval: 5,
                                getTitlesWidget:
                                    (value, meta) => Text(
                                      value.toString(),
                                      style: TextStyle(
                                        color: AppColors.thirtary,
                                        fontSize: 10,
                                      ),
                                    ),
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: chartData,
                              isCurved: true,
                              color: Colors.white,
                              dotData: FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
