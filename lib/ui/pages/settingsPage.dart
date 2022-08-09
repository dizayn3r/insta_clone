import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
    double h = sizingInformation.screenSize.height / 100;
    double w = sizingInformation.screenSize.width / 100;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.grey.shade900),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: w * 90,
            padding: EdgeInsets.all(h * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Detail',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: w * 5.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: h),
                Text(
                  user.email!,
                  style: TextStyle(
                    fontSize: w * 4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 2),
          GestureDetector(
            onTap: () => logout(),
            child: Container(
              height: w * 15,
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: w * 5,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(w * 1.5),
              ),
              child: Text(
                'Log Out',
                style: TextStyle(color: Colors.white, fontSize: w * 5),
              ),
            ),
          ),

        ],
      ),
    );
      },
    );
  }
  Future<void> logout() async {
    auth.signOut();
    Navigator.canPop(context);
  }
}
