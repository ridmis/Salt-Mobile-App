import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/reusable_components/components.dart';
import 'package:myapp/reusable_components/large_elevated_button.dart';
import 'package:myapp/reusable_components/profile_drawer.dart';

class Rainfall extends StatefulWidget {
  @override
  _RainfallState createState() => _RainfallState();
}

class _RainfallState extends State<Rainfall> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
                      Text(
                        "Rainfall",
                        style: headingTextStyle.copyWith(fontSize: 20),
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

      // body: Stack(
      //   children: [

      //     SafeArea(
      //       child: Column(
      //         children: [
      //           const SizedBox(height: 20),
      //           Image.asset('assets/rainfall.png', height: 250, width: 300),
      //           Container(
      //             width: double.infinity,
      //             padding: const EdgeInsets.all(24),
      //             child: Column(
      //               children: [
      //                 Align(
      //                   alignment: Alignment.centerLeft,
      //                   child: Text(
      //                     currentDate,
      //                     style: const TextStyle(color: Colors.white),
      //                   ),
      //                 ),

      //                 const SizedBox(height: 24),

      //                 // 🔽 Lewaya Dropdown
      //                 Container(
      //                   padding: const EdgeInsets.symmetric(horizontal: 16),
      //                   decoration: BoxDecoration(
      //                     color: Colors.white,
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                   child: DropdownButtonHideUnderline(
      //                     child: DropdownButton<String>(
      //                       isExpanded: true,
      //                       value:
      //                           selectedOption.isEmpty ? null : selectedOption,
      //                       hint: const Text("Select"),
      //                       items:
      //                           dropdownItems.map((String value) {
      //                             return DropdownMenuItem<String>(
      //                               value: value,
      //                               child: Text(value),
      //                             );
      //                           }).toList(),
      //                       onChanged: (value) {
      //                         setState(() {
      //                           selectedOption = value!;
      //                         });
      //                       },
      //                     ),
      //                   ),
      //                 ),

      //                 const SizedBox(height: 20),

      //                 // TextField for rainfall value
      //                 TextField(
      //                   controller: _textController,
      //                   keyboardType: TextInputType.number,
      //                   decoration: InputDecoration(
      //                     filled: true,
      //                     fillColor: Colors.white,
      //                     hintText: 'Enter value',
      //                     border: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(10),
      //                       borderSide: BorderSide.none,
      //                     ),
      //                   ),
      //                 ),

      //                 const SizedBox(height: 20),

      //                 // Submit Button
      //                 ElevatedButton(
      //                   onPressed: () async {
      //                     if (selectedOption.isEmpty ||
      //                         _textController.text.isEmpty) {
      //                       ScaffoldMessenger.of(context).showSnackBar(
      //                         const SnackBar(
      //                           content: Text(
      //                             "Please select a location and enter a value",
      //                           ),
      //                         ),
      //                       );
      //                       return;
      //                     }

      //                     String input = _textController.text.trim();
      //                     final regex = RegExp(r'^\d{1,2}(\.\d{1,2})?$');

      //                     if (!regex.hasMatch(input)) {
      //                       ScaffoldMessenger.of(context).showSnackBar(
      //                         const SnackBar(
      //                           content: Text("Invalid rainfall format"),
      //                         ),
      //                       );
      //                       return;
      //                     }

      //                     double value = double.parse(input);
      //                     String formattedDate = DateFormat(
      //                       'yyyy-MM-dd',
      //                     ).format(DateTime.now());

      //                     DatabaseReference dbRef = FirebaseDatabase.instance
      //                         .ref()
      //                         .child('rainfall/$selectedOption/$formattedDate');

      //                     try {
      //                       await dbRef.set(value);
      //                       ScaffoldMessenger.of(context).showSnackBar(
      //                         const SnackBar(
      //                           content: Text("Rainfall data submitted"),
      //                         ),
      //                       );

      //                       setState(() {
      //                         _textController.clear();
      //                         selectedOption = '';
      //                       });
      //                     } catch (e) {
      //                       ScaffoldMessenger.of(context).showSnackBar(
      //                         SnackBar(content: Text("Error saving data: $e")),
      //                       );
      //                     }
      //                   },
      //                   style: ElevatedButton.styleFrom(
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(30),
      //                     ),
      //                     backgroundColor: Colors.white,
      //                     padding: const EdgeInsets.symmetric(
      //                       vertical: 12,
      //                       horizontal: 30,
      //                     ),
      //                   ),
      //                   child: const Text(
      //                     'Submit',
      //                     style: TextStyle(
      //                       color: Color(0xFF283593),
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.6),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),

                  image: DecorationImage(
                    image: AssetImage("assets/rain.gif"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rainfall Details", style: headingTextStyle),
                    SizedBox(height: 20),
                    CustomTextField(
                      readOnly: true,
                      controller: TextEditingController(),
                      hintText: currentDate,
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),

                    SizedBox(height: 30),
                    Text("Please select the Lewaya", style: smallTextStyle),
                    SizedBox(height: 15),
                    // CustomTextField(
                    //   controller: TextEditingController(),
                    //   hintText: "Select",
                    //   icon: Icons.location_pin,
                    //   readOnly: false,
                    // ),
                    // 🔽 Lewaya Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: greyColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedOption.isEmpty ? null : selectedOption,
                          hint: Row(
                            children: [
                              Icon(Icons.location_pin),
                              SizedBox(width: 15),
                              Text("Select", style: smallTextStyle),
                            ],
                          ),
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
                    SizedBox(height: 30),
                    CustomTextField(
                      controller: _textController,
                      hintText: "Enter Rainfall Value (mm)",
                      icon: Icons.water_drop_rounded,
                      readOnly: false,
                      isPassword: false,
                      obscureText: false,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(height: 40),
                    LargeElevatedButton(
                      title: "Submit",
                      onPressed: () async {
                        if (selectedOption.isEmpty ||
                            _textController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              backgroundColor: redColor,

                              content: Text(
                                textAlign: TextAlign.center,
                                "Please select a location and enter a value",
                                style: smallTextStyle.copyWith(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                          return;
                        }

                        String input = _textController.text.trim();
                        final regex = RegExp(r'^\d{1,2}(\.\d{1,2})?$');

                        if (!regex.hasMatch(input)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              backgroundColor: redColor,

                              content: Text(
                                textAlign: TextAlign.center,
                                "Invalid rainfall format",
                                style: smallTextStyle.copyWith(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                            SnackBar(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              backgroundColor: greenColor,

                              content: Text(
                                textAlign: TextAlign.center,
                                "Rainfall data submitted",
                                style: smallTextStyle.copyWith(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );

                          setState(() {
                            _textController.clear();
                            selectedOption = '';
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              backgroundColor: redColor,

                              content: Text(
                                textAlign: TextAlign.center,
                                "Error saving data: $e",
                                style: smallTextStyle.copyWith(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
