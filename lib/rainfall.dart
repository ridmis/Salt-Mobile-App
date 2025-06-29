import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/AppColors.dart';

class Rainfall extends StatefulWidget {
  @override
  _RainfallState createState() => _RainfallState();
}

class _RainfallState extends State<Rainfall> {
  final TextEditingController _textController = TextEditingController();

  List<String> dropdownItems = [];
  String selectedOption = '';

  @override
  void initState() {
    super.initState();
    fetchLewayaNames();
  }

  void fetchLewayaNames() async {
    final dbRef = FirebaseDatabase.instance.ref().child('Lewaya');
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      List<String> names = [];

      data.forEach((key, value) {
        names.add(value['name']);
      });

      setState(() {
        dropdownItems = names;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('yyyy/MM/dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rainfall',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: -25,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset('assets/rainfall.png', height: 250, width: 300),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          currentDate,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 🔽 Lewaya Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value:
                                selectedOption.isEmpty ? null : selectedOption,
                            hint: const Text("Select"),
                            items:
                                dropdownItems.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value!;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // TextField for rainfall value
                      TextField(
                        controller: _textController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter value',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Submit Button
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedOption.isEmpty ||
                              _textController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please select a location and enter a value",
                                ),
                              ),
                            );
                            return;
                          }

                          String input = _textController.text.trim();
                          final regex = RegExp(r'^\d{1,2}(\.\d{1,2})?$');

                          if (!regex.hasMatch(input)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Invalid rainfall format"),
                              ),
                            );
                            return;
                          }

                          double value = double.parse(input);
                          String formattedDate = DateFormat(
                            'yyyy-MM-dd',
                          ).format(DateTime.now());

                          DatabaseReference dbRef = FirebaseDatabase.instance
                              .ref()
                              .child('rainfall/$selectedOption/$formattedDate');

                          try {
                            await dbRef.set(value);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Rainfall data submitted"),
                              ),
                            );

                            setState(() {
                              _textController.clear();
                              selectedOption = '';
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error saving data: $e")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 30,
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Color(0xFF283593),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
