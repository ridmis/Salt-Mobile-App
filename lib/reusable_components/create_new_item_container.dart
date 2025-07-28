import 'package:flutter/material.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;

class CreateNewItemContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final String image;
  final String title;
  final String subtitle;
  const CreateNewItemContainer({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: MediaQuery.of(context).size.height * .15,
        height:
            global.isTablet
                ? MediaQuery.of(context).size.height * .20
                : MediaQuery.of(context).size.height * .18,
        width: MediaQuery.of(context).size.width,
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
                // height: MediaQuery.of(context).size.height * 0.15,
                height:
                    global.isTablet
                        ? MediaQuery.of(context).size.height * .20
                        : MediaQuery.of(context).size.height * .18,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.transparent,
                      greyColor.withOpacity(.2),
                      blackColor.withOpacity(0.4),
                      blackColor.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: headingTextStyle.copyWith(color: whiteColor),
                      ),
                      Text(
                        subtitle,
                        style: headingTextStyle.copyWith(color: whiteColor),
                      ),
                      SizedBox(height: 10),
                    ],
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
