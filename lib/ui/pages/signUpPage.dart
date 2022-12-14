import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../auth/reference/user_data_reference.dart';
import '../../model/user_model.dart';
import '../../widgets/showSnackbar.dart';
import '../styles/color.dart';
import 'homePage.dart';
import 'loginPage.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  //FirebaseAuth
  final auth = FirebaseAuth.instance;
  UserModel userModel = UserModel();

  String? errorMessage;

  //FocusNode
  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  late String _name, _email, _password, _confirmPassword;
  //
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    focusNodeEmail.dispose();
    focusNodeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      double h =
          (sizingInformation.screenSize.height / 100).roundToDouble(); // 8.0
      double w =
          (sizingInformation.screenSize.width / 100).roundToDouble(); // 4.0
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
                      margin: EdgeInsets.only(top: w * 20, bottom: w * 10),
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
                      margin: EdgeInsets.only(bottom: w * 2),
                      child: Text(
                        'Create\nyour account',
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
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            TextFormField(
                              focusNode: focusNodeName,
                              controller: signupNameController,
                              keyboardType: TextInputType.name,
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                RegExp regex = RegExp(r'^.{3,}$');
                                if (value!.isEmpty) {
                                  return ("Name cannot be Empty");
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Enter Valid name (Min. 3 Character)");
                                } else {
                                  _name = value;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person,
                                ),
                                contentPadding: EdgeInsets.fromLTRB(
                                  w * 5,
                                  w * 4,
                                  w * 5,
                                  w * 4,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                  ),
                                ),
                                hintText: 'Name',
                              ),
                              onSaved: (value) {
                                _name = value!;
                                focusNodeEmail.requestFocus();
                              },
                            ),
                            SizedBox(height: w * 2),
                            TextFormField(
                              focusNode: focusNodeEmail,
                              controller: signupEmailController,
                              keyboardType: TextInputType.emailAddress,
                              textAlignVertical: TextAlignVertical.center,
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
                                hintText: 'Email',
                                contentPadding: EdgeInsets.fromLTRB(
                                  w * 5,
                                  w * 4,
                                  w * 5,
                                  w * 4,
                                ),
                                prefixIcon: const Icon(
                                  Icons.alternate_email_rounded,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              onSaved: (value) {
                                _email = value!;
                                focusNodePassword.requestFocus();
                              },
                            ),
                            SizedBox(height: w * 2),
                            TextFormField(
                              focusNode: focusNodePassword,
                              controller: signupPasswordController,
                              obscureText: _obscureTextPassword,
                              keyboardType: TextInputType.text,
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
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
                                hintText: 'Password',
                                contentPadding: EdgeInsets.fromLTRB(
                                  w * 5,
                                  w * 4,
                                  w * 5,
                                  w * 4,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.lock_rounded),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleSignup,
                                  child: Icon(
                                    _obscureTextPassword
                                        ? Icons.remove_red_eye_outlined
                                        : Icons.remove_red_eye_rounded,
                                  ),
                                ),
                              ),
                              onSaved: (value) {
                                _password = value!;
                                focusNodeConfirmPassword.requestFocus();
                              },
                            ),
                            SizedBox(height: w * 2),
                            TextFormField(
                              focusNode: focusNodeConfirmPassword,
                              controller: signupConfirmPasswordController,
                              obscureText: _obscureTextConfirmPassword,
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                RegExp regex = RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return ("Password is required for login");
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Enter Valid Password (Min. 6 character)");
                                } else {
                                  _confirmPassword = value;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                contentPadding: EdgeInsets.fromLTRB(
                                  w * 5,
                                  w * 4,
                                  w * 5,
                                  w * 4,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock_rounded,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleSignupConfirm,
                                  child: Icon(
                                    _obscureTextConfirmPassword
                                        ? Icons.remove_red_eye_outlined
                                        : Icons.remove_red_eye_rounded,
                                  ),
                                ),
                              ),
                              onSaved: (value) {
                                _confirmPassword = value!;
                                focusNodeConfirmPassword.requestFocus();
                              },
                            ),
                            SizedBox(height: w * 4),
                            GestureDetector(
                              onTap: () => signUp(context),
                              child: Container(
                                height: w * 12,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(w * 2),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: onPrimary, fontSize: w * 5),
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
                          "Already have an account?",
                          style: TextStyle(fontSize: w * 4),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                          child: Text(
                            'Log In',
                            textAlign: TextAlign.end,
                            style: TextStyle(
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
    });
  }

  Future signUp(context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await auth
            .createUserWithEmailAndPassword(email: _email, password: _password)
            .then((value) => {storeUserDetail(context)})
            .catchError((e) {
          showSnackBar(context, e!.message);
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
        showSnackBar(context, errorMessage!);
      }
    }
  }

  storeUserDetail(context) async {
    User? user = auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.displayName = _name;

    await UserDataReference().userData().doc(user.uid).set(userModel.toMap());
    showSnackBar(context,
        "Account created successfully");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }
}
