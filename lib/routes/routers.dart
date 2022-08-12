import 'package:flutter/material.dart';
import '../ui/pages/signUpPage.dart';
import '../ui/pages/loginPage.dart';
import '../ui/pages/splashPage.dart';
import '../ui/pages/homePage.dart';


class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'splash':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case 'home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case 'login':
        return MaterialPageRoute(builder: (_) => const Login());
      case 'signUp':
        return MaterialPageRoute(builder: (_) => const SignUp());
      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            );
          },
        );
    }
  }
}
