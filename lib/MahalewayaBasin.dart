import 'package:flutter/material.dart';
import 'package:myapp/AppColors.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/reusable_components/large_elevated_button.dart';
import 'package:myapp/reusable_components/profile_drawer.dart';

class MahalewayaBasin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final basinNo = ModalRoute.of(context)!.settings.arguments as String?;
    return MahalewayaForm(basinNo: basinNo ?? '');
  }
}

class MahalewayaForm extends StatefulWidget {
  final String basinNo;

  MahalewayaForm({required this.basinNo});

  @override
  _MahalewayaFormState createState() => _MahalewayaFormState();
}

class _MahalewayaFormState extends State<MahalewayaForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController poolNameController;
  late TextEditingController upperDensityController;
  late TextEditingController lowerDensityController;
  late TextEditingController depthController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name = global.SelectedLName;

  bool isEditing = false;
  String? editKey;

  @override
  void initState() {
    super.initState();
    poolNameController = TextEditingController(text: global.selectedPoolName);
    upperDensityController = TextEditingController();
    lowerDensityController = TextEditingController();
    depthController = TextEditingController();

    fetchExistingData();
  }

  void fetchExistingData() async {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final ref = FirebaseDatabase.instance.ref('Reading_Details/1/1');

    final snapshot = await ref.get();
    if (snapshot.exists && snapshot.value is Map) {
      final data = snapshot.value as Map;
      data.forEach((key, value) {
        if (value['P_Name'] == global.selectedPoolName &&
            value['Date'] == date &&
            value['userId'] == global.userId) {
          setState(() {
            editKey = key;
            isEditing = true;
          });
        }
      });
    }
  }

  void loadEditData() async {
    if (editKey == null) return;
    final ref = FirebaseDatabase.instance.ref('Reading_Details/1/1/$editKey');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        upperDensityController.text = data['U_Density(Kgm-3)'].toString();
        lowerDensityController.text = data['L_Density(Kgm-3)'].toString();
        depthController.text = data['Depth'].toString();
      });
    }
  }

  @override
  void dispose() {
    poolNameController.dispose();
    upperDensityController.dispose();
    lowerDensityController.dispose();
    depthController.dispose();
    super.dispose();
  }

  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    double upper = double.parse(upperDensityController.text);
    double lower = double.parse(lowerDensityController.text);
    double depth = double.parse(depthController.text);
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String currentTime = DateFormat('HH.mm').format(DateTime.now());

    DatabaseReference ref = FirebaseDatabase.instance.ref(
      'Reading_Details/1/1',
    );

    try {
      if (isEditing && editKey != null) {
        await ref.child(editKey!).update({
          "U_Density(Kgm-3)": upper,
          "L_Density(Kgm-3)": lower,
          "Depth": depth,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: EdgeInsets.symmetric(vertical: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            backgroundColor: greenColor,

            content: Text(
              textAlign: TextAlign.center,
              "Data updated successfully",
              style: smallTextStyle.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {
        await ref.push().set({
          "Date": today,
          "Time": currentTime,
          "L_Id": global.selectedLId,
          "T_Id": global.SelectedTypeId,
          "P_Id": global.selectedPId,
          "P_Name": global.selectedPoolName,
          "U_Density(Kgm-3)": upper,
          "L_Density(Kgm-3)": lower,
          "Depth": depth,
          "userId": global.userId,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: EdgeInsets.symmetric(vertical: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            backgroundColor: greenColor,

            content: Text(
              textAlign: TextAlign.center,
              "Data submitted successfully",
              style: smallTextStyle.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }

      upperDensityController.clear();
      lowerDensityController.clear();
      depthController.clear();
      _formKey.currentState!.reset();

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: AppColors.primary,
    //   extendBodyBehindAppBar: true,
    //   appBar: AppBar(
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //     leading: IconButton(
    //       icon: Icon(Icons.arrow_back, color: AppColors.thirtary),
    //       onPressed: () => Navigator.pop(context),
    //     ),
    //     actions: [
    //       if (isEditing)
    //         IconButton(
    //           icon: const Icon(Icons.edit, color: AppColors.thirtary),
    //           onPressed: () {
    //             loadEditData();
    //           },
    //         ),
    //     ],
    //   ),
    //   body: Stack(
    //     children: [
    //       Positioned(top: -100, left: -100, child: _circle(300)),
    //       Positioned(top: 600, right: -70, child: _circle(300)),
    //       SafeArea(
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 30),
    //           child: Column(
    //             children: [
    //               const SizedBox(height: 40),
    //               Text(
    //                 '${global.SelectedLName} - ${global.selectedTypeName}',
    //                 style: const TextStyle(
    //                   fontSize: 26,
    //                   fontWeight: FontWeight.bold,
    //                   color: AppColors.thirtary,
    //                 ),
    //               ),
    //               const SizedBox(height: 40),
    //               Form(
    //                 key: _formKey,
    //                 child: Column(
    //                   children: [
    //                     formLabel(global.selectedTypeName),
    //                     customInputField(
    //                       controller: poolNameController,
    //                       readOnly: true,
    //                     ),
    //                     formLabel("Upper Density ( Be )"),
    //                     customInputField(
    //                       controller: upperDensityController,
    //                       keyboardType: TextInputType.numberWithOptions(
    //                         decimal: true,
    //                       ),
    //                     ),
    //                     formLabel("Lower Density ( Be )"),
    //                     customInputField(
    //                       controller: lowerDensityController,
    //                       keyboardType: TextInputType.numberWithOptions(
    //                         decimal: true,
    //                       ),
    //                     ),
    //                     formLabel("Depth ( in )"),
    //                     customInputField(
    //                       controller: depthController,
    //                       keyboardType: TextInputType.numberWithOptions(
    //                         decimal: true,
    //                       ),
    //                     ),
    //                     const SizedBox(height: 20),
    //                     Center(
    //                       child: ElevatedButton(
    //                         onPressed: handleSubmit,
    //                         style: ElevatedButton.styleFrom(
    //                           backgroundColor: AppColors.thirtary,
    //                           foregroundColor: AppColors.primary,
    //                           shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(20),
    //                           ),
    //                         ),
    //                         child: Padding(
    //                           padding: const EdgeInsets.symmetric(
    //                             horizontal: 24,
    //                             vertical: 8,
    //                           ),
    //                           child: Text(isEditing ? 'Save' : 'Submit'),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
                            "Baume Readings",
                            style: headingTextStyle.copyWith(fontSize: 20),
                          ),
                          Text(
                            name,
                            style: headingTextStyle.copyWith(fontSize: 16),
                          ),
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
                  // radius: MediaQuery.of(context).size.width * 0.06,
                  radius: 30,
                  backgroundImage: AssetImage("assets/Sample_User_Icon.png"),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.25,
                height:
                    global.isTablet
                        ? MediaQuery.of(context).size.height * 0.30
                        : MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.6),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),

                  image: DecorationImage(
                    image: AssetImage("assets/istock-484942148.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${global.selectedTypeName} Details",
                        style: headingTextStyle,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "${global.selectedTypeName} Number",
                        style: smallTextStyle,
                      ),
                      SizedBox(height: 10),
                      customInputField(
                        icon: Icons.my_location_rounded,
                        hintText: "${global.selectedPoolName}",
                        controller: poolNameController,
                        readOnly: true,
                      ),

                      SizedBox(height: 20),
                      Text("Upper Density (Be)", style: smallTextStyle),
                      SizedBox(height: 10),
                      customInputField(
                        icon: Icons.trending_up_rounded,
                        hintText: "10.0 Kg/m³",
                        controller: upperDensityController,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      Text("Lower Density (Be)", style: smallTextStyle),
                      SizedBox(height: 10),
                      customInputField(
                        icon: Icons.trending_down_rounded,
                        hintText: "10.0 Kg/m³",
                        controller: lowerDensityController,
                        keyboardType: TextInputType.number,
                      ),

                      SizedBox(height: 20),
                      Text("Depth (in)", style: smallTextStyle),
                      SizedBox(height: 10),
                      customInputField(
                        icon: Icons.arrow_downward_rounded,
                        hintText: "10.0 m",
                        controller: depthController,
                        readOnly: false,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 30),

                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: LargeElevatedButton(
                              title: "Save",
                              onPressed: () {
                                handleSubmit();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(color: AppColors.thirtary, fontSize: 16),
      ),
    ),
  );
  Widget customInputField({
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      cursorColor: greyColor,
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: (value) {
        if (!readOnly && (value == null || value.isEmpty)) {
          return 'Please enter a value';
        }
        final regex = RegExp(r'^\d{1,2}(\.\d{1,2})?$');
        if (!readOnly && !regex.hasMatch(value!)) {
          return 'Max 2 digits before and after decimal';
        }
        return null;
      },
      decoration: InputDecoration(
        icon: Icon(icon),
        hintText: hintText,
        hintStyle: smallTextStyle,
        filled: true,
        fillColor: greyColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Widget _circle(double size) => Container(
  //   width: size,
  //   height: size,
  //   decoration: BoxDecoration(
  //     color: AppColors.secondary,
  //     shape: BoxShape.circle,
  //   ),
  // );
}
