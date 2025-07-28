import 'package:flutter/material.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;

class DashboardContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final String image;
  final String title;
  // final String subtitle;
  const DashboardContainer({
    super.key,
    required this.image,
    required this.title,
    // required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: MediaQuery.of(context).size.height * .18,
        height:
            global.isMobile
                ? MediaQuery.of(context).size.height * 0.18
                : MediaQuery.of(context).size.height * 0.18,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              // bottom: -20,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                // width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      // Colors.transparent,
                      Color(0xFF03A9A7).withOpacity(.2),
                      Color(0xFF03A9A7).withOpacity(.5),
                      Color(0xFF03A9A7).withOpacity(.8),
                      Color(0xFF196867).withOpacity(.9),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    title,
                    style: headingTextStyle.copyWith(
                      color: whiteColor,
                      fontSize: 20,
                    ),
                  ),
                  // Text(
                  //   subtitle,
                  //   style: smallTextStyle.copyWith(color: whiteColor),
                  // ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
