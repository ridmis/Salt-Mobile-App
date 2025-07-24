import 'package:flutter/material.dart';
import 'package:myapp/constant.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myapp/reusable_components/large_elevated_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0), // Start from right
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: AssetImage("assets/Epsom-Salts.jpg"),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0xFF8284BE).withOpacity(.4),
                      Color(0xFF00706E).withOpacity(.7),
                      Color(0xFF00706E),
                      Color(0xFF00706E),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.03,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "bgImage",
                    child: Image(
                      image: AssetImage("assets/Lanka-Salt-Logo.png"),
                    ),
                  ),
                  Text(
                    'Lanka Salt Ltd.',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "The Best Salt Producer in the Country",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: whiteColor,
                    ),
                  ),
                  SizedBox(height: 50),
                  LargeElevatedButton(
                    title: "Sign In",
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                      // Navigator.pushNamed(context, '/admin');
                    },
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Powered by",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: whiteColor,
                    ),
                  ),
                  Image(
                    image: AssetImage("assets/Logo-SLT.png"),
                    width: 90,
                    height: 35,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Scaffold(
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           Image(
//             image: AssetImage("images/Epsom-Salts.jpg"),
//             fit: BoxFit.cover,
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.7,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Color(0xFF8284BE).withOpacity(.4),
//                     Color(0xFF00706E).withOpacity(.7),
//                     Color(0xFF00706E),
//                     Color(0xFF00706E),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: MediaQuery.of(context).size.height * 0.03,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Hero(
//                   tag: "bgImage",
//                   child: Image(image: AssetImage("images/Lanka-Salt-Logo.png")),
//                 ),
//                 Text(
//                   'Lanka Salt Ltd.',
//                   style: TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.w900,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Text(
//                   "The Best Salt Producer in the Country",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.normal,
//                     color: whiteColor,
//                   ),
//                 ),
//                 SizedBox(height: 50),
//                 LargeElevatedButton(
//                   title: "Sign In",
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/login');
//                   },
//                 ),
//                 SizedBox(height: 40),
//                 Text(
//                   "Powered by",
//                   style: TextStyle(
//                     fontStyle: FontStyle.italic,
//                     fontSize: 14,
//                     fontWeight: FontWeight.normal,
//                     color: whiteColor,
//                   ),
//                 ),
//                 Image(
//                   image: AssetImage("images/Logo-SLT.png"),
//                   width: 90,
//                   height: 35,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
