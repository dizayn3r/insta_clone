import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/auth/reference/user_data_reference.dart';
import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/ui/pages/addPostPage.dart';
import 'package:insta_clone/ui/pages/postPage.dart';
import 'package:insta_clone/ui/pages/splashPage.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../styles/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  UserModel userModel = UserModel();
  final auth = FirebaseAuth.instance;

  @override
  initState() {
    UserDataReference()
        .userData()
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => userModel = UserModel.fromMap(value.data()));
    setState(() {});
    super.initState();
  }

  int pageIndex = 0;

  signOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SplashPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      PostPage(),
      AddPost(userId: userModel.uid),
    ];
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double w = sizingInformation.screenSize.shortestSide / 100;
        return SafeArea(
          child: Scaffold(
            backgroundColor: onPrimary,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: onPrimary,
              actions: [
                IconButton(
                  onPressed: () => signOut(context),
                  icon: Icon(Icons.logout_rounded, color: primary),
                ),
              ],
            ),
            body: pages.elementAt(pageIndex),
            bottomNavigationBar: navBar(context, w),
          ),
        );
      },
    );
  }

  Widget navBar(BuildContext context, double widthBlock) => Container(
    color: onPrimary,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                pageIndex = 0;
              });
            },
            child: Container(
              height: widthBlock * 15,
              color: pageIndex == 0 ? primary : onPrimary,
              child: Icon(
                Icons.rss_feed_rounded,
                color: pageIndex == 0
                    ? onPrimary
                    : textColor.withOpacity(0.25),
                size: pageIndex == 0 ? widthBlock * 8 : widthBlock * 7,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                pageIndex = 1;
              });
            },
            child: Container(
                height: widthBlock * 15,
                color: pageIndex == 1 ? primary : onPrimary,
                child: Icon(
                  Icons.add_rounded,
                  color: pageIndex == 1
                      ? onPrimary
                      : textColor.withOpacity(0.25),
                  size: pageIndex == 1 ? widthBlock * 8 : widthBlock * 7,
                )),
          ),
        ),
      ],
    ),
  );
}