import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/Admin.dart';

// Import app screens
import 'package:myapp/LoadingScreen.dart';
import 'package:myapp/HomeScreen.dart';
import 'package:myapp/Pools.dart';
import 'package:myapp/SignIn_Page.dart';
import 'package:myapp/Dashboard.dart';
import 'package:myapp/rainfall.dart';
import 'package:myapp/BrinePage.dart';
import 'package:myapp/SelectType.dart';
import 'package:myapp/MahalewayaBasin.dart';


// Import new admin-related pages
import 'package:myapp/AddUserAdmin.dart';
import 'package:myapp/CreateItems.dart';
import 'package:myapp/ReportSection.dart';
import 'package:myapp/AnalyseSection.dart';
import 'package:myapp/ReadingSection.dart';
import 'package:myapp/ChangeItems.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAZUlW7N-CgZkIwAYdIQinkfOGvA9jL90s",
        authDomain: "saltlanka-ec970.firebaseapp.com",
        projectId: "saltlanka-ec970",
        storageBucket: "saltlanka-ec970.appspot.com",
        messagingSenderId: "253060968567",
        appId: "1:253060968567:web:a89620f10badd653375672",
        databaseURL:
            "https://saltlanka-ec970-default-rtdb.asia-southeast1.firebasedatabase.app",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingScreen(),
        '/login': (context) => SignIn(),
        '/home': (context) => HomeScreen(),
        '/dashboard': (context) => Dashboard(),
        '/rainfall': (context) => Rainfall(),
        '/brine': (context) => SelectBrineScreen(),
        '/selecttype': (context) => SelectTypeScreen(),
        '/admin': (context) => AdminPage(),
        '/pools': (context) => SelectPool(),
        '/polls': (context) => SelectPool(),

        
        '/mbasin': (context) => MahalewayaBasin(),
        

        // Admin panel extra pages
        '/addUser': (context) => AddUserAdmin(),
        '/createItems': (context) => CreateItems(),
        '/reportSection': (context) => ReportSection(),
        '/analyseSection': (context) => AnalyseSection(),
        '/readingSection': (context) => ReadingSection(),
        '/changeItems': (context) => ChangeItems(),
      },
    );
  }
}
