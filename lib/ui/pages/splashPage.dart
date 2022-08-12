import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/ui/pages/loginPage.dart';
import 'package:insta_clone/ui/pages/homePage.dart';

import 'dart:async';

import 'package:responsive_builder/responsive_builder.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
          () =>
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
              FirebaseAuth.instance.currentUser == null
                  ? const Login()
                  : const HomePage(),
            ),
          ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double w = (sizingInformation.screenSize.shortestSide / 100)
            .roundToDouble();
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Image.asset(
            "assets/logo.png",
            width: w * 30,
          ),
        );
      },
    );
  }
}


