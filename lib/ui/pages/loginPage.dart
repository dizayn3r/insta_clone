import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/ui/pages/homePage.dart';
import 'package:insta_clone/ui/pages/signUpPage.dart';
import 'package:insta_clone/widgets/showSnackbar.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../styles/color.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String _email, _password;
  final auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;

  String? errorMessage;

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double h = (sizingInformation.screenSize.height / 100).roundToDouble(); // 8.0
        double w = (sizingInformation.screenSize.width / 100).roundToDouble(); // 4.0
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: h * 88,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top:w *20 , bottom: w * 10),
                        child: Image.asset(
                          "assets/logo.png",
                          color: primary,
                          height: w * 30,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: w * 20,
                        padding: EdgeInsets.symmetric(horizontal: w * 4),
                        margin: EdgeInsets.only(bottom:w*2),
                        child: Text(
                          'Log into\nyour account',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: w * 5,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: w * 4),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                focusNode: focusNodeEmail,
                                controller: loginEmailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ('Please enter your email');
                                  }
                                  if (!RegExp(
                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9+_.-]+.[a-z]")
                                      .hasMatch(value)) {
                                    return ("Please enter a valid email");
                                  } else {
                                    _email = value;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon:
                                  const Icon(Icons.alternate_email_rounded),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 1)),
                                  contentPadding: EdgeInsets.fromLTRB(
                                    w * 5,
                                    w * 4,
                                    w * 5,
                                    w * 4,
                                  ),
                                  hintText: 'Email',
                                ),
                                onSaved: (value) {
                                  _email = value!.trim();
                                  focusNodePassword.requestFocus();
                                },
                              ),
                              SizedBox(height: w * 2),
                              TextFormField(
                                focusNode: focusNodePassword,
                                controller: loginPasswordController,
                                obscureText: _obscureTextPassword,
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{6,}$');
                                  if (value!.isEmpty) {
                                    return ("Password is required for login");
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ("Enter Valid Password (Min. 6 character)");
                                  } else {
                                    _password = value;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.0,
                                    ),
                                  ),
                                  prefixIcon: Icon(Icons.lock_rounded),
                                  suffixIcon: GestureDetector(
                                    onTap: _toggleLogin,
                                    child: Icon(
                                      _obscureTextPassword
                                          ? Icons.remove_red_eye_outlined
                                          : Icons.remove_red_eye_rounded,
                                    ),
                                  ),
                                  hintText: 'Password',
                                  contentPadding: EdgeInsets.fromLTRB(
                                    w * 5,
                                    w * 4,
                                    w * 5,
                                    w * 4,
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) {
                                  _password = value.trim();
                                },
                              ),
                              SizedBox(height: w * 4),
                              GestureDetector(
                                onTap: () => signIn(context),
                                child: Container(
                                  height: w * 12,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(w * 2),
                                  ),
                                  child: Text(
                                    'Log in',
                                    style: TextStyle(color: onPrimary, fontSize: w * 5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
               Container(
                 height: h * 9,
                 child: Column(
                   children: [
                     Divider(color: textColor),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text(
                           "Don't have an account?",
                           style: TextStyle(fontSize: w * 4),
                         ),
                         TextButton(
                           onPressed: () {
                             Navigator.of(context).pushReplacement(
                               MaterialPageRoute(
                                 builder: (context) => const SignUp(),
                               ),
                             );
                           },
                           child: Text(
                             'Sign Up',
                             textAlign: TextAlign.end,
                             style: TextStyle(color: primary,
                                 fontWeight: FontWeight.bold, fontSize: w * 4),
                           ),
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
      },
    );
  }

  Future signIn(context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await auth
            .signInWithEmailAndPassword(email: _email, password: _password)
            .then((uid) => {
          showSnackBar(context, "Login Successful"),
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ))
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        showSnackBar(
          context,
          errorMessage!,
        );
      }
    }
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
}