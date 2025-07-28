import 'package:flutter/material.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .75,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              // padding: EdgeInsets.symmetric(vertical: 85),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      // radius: MediaQuery.of(context).size.width * 0.12,
                      radius: 60,
                      backgroundImage: AssetImage(
                        "assets/Sample_User_Icon.png",
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(global.userName, style: headingTextStyle),
                    Text(global.userType, style: smallTextStyle),
                  ],
                ),
                SizedBox(height: 15),

                Divider(),
                SizedBox(height: 25),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout', style: smallTextStyle),
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                    // Add logout functionality here
                  },
                ),
              ],
            ),
            Positioned(
              bottom: 5,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Powered by",
                      style: smallTextStyle.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),

                    Image.asset("assets/slt logo.png", height: 80, width: 80),
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
