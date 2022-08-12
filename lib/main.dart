import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/routes/routers.dart';
import 'ui/styles/color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insta Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: onPrimary,
        primarySwatch: crimson,
      ),
      initialRoute: 'splash',
      onGenerateRoute: Routers.generateRoute,
    );
  }
}