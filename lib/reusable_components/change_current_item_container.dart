import 'package:flutter/material.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/reusable_components/large_elevated_button.dart';
import 'package:myapp/reusable_components/small_elevated_button.dart';

class ChangeCurrentItemContainer extends StatelessWidget {
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;
  final String image;
  final String title;
  const ChangeCurrentItemContainer({
    super.key,
    required this.image,
    required this.title,
    this.onUpdate,
    this.onDelete,
    

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      child: Container(
        height: MediaQuery.of(context).size.height * .15,
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
                // clipBehavior: Clip.antiAlias,
                height: MediaQuery.of(context).size.height * 0.15,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    title,
                    style: headingTextStyle.copyWith(color: whiteColor),
                  ),

                  SizedBox(height: 10),
                  Row(
                    children: [
                      SmallElevatedButton(title: "Update", onPressed: onUpdate),
                      SizedBox(width: 10),
                      SmallElevatedButton(
                        title: "Delete",
                        onPressed: onDelete,
                        color: redColor,
                      ),
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
