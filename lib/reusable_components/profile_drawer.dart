import 'package:flutter/material.dart';
// import 'package:myapp/AppColors.dart';
import 'package:myapp/constant.dart';
import 'package:myapp/global.dart' as global;

String userName = global.userId;

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.12,
                      backgroundImage: AssetImage("assets/salt.png"),
                    ),
                    SizedBox(height: 20),
                    Text(userName, style: headingTextStyle),
                    Text("901901313 - Updater", style: smallTextStyle),
                  ],
                ),
                SizedBox(height: 15),

                Divider(),
                SizedBox(height: 25),

                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout', style: smallTextStyle),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      (Route<dynamic> route) => false,
                    );
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
