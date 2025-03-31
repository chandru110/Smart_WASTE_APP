import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenearn/FirebaseFunctions/Auth.dart';
import 'package:greenearn/Screens/User%20Screen/Ui/MyText.dart';
import 'package:greenearn/Screens/User%20Screen/Ui/Sign_in.dart';
import 'package:greenearn/Screens/User%20Screen/bloc/user_bloc.dart';
import 'package:greenearn/Screens/main_screen/UI/main_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    userbloc.add(UserInititialEvent());
    super.initState();
  }

  void tryvalidate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      print("Validation Failed");
    }
  }

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_slash_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      bloc: userbloc,
      listenWhen: (previous, current) => current is UserActionState,
      buildWhen: (previous, current) => current is! UserActionState,
      listener: (context, state) async {
        if (state is UserSignupAuthState) {
          final authResponse =
              await SignupFirebase.signup(state.email, state.pssword);
          if (authResponse.success) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MainScreen();
            }));
            // Navigate to the blank page on successful signup
          } else {
            // Optionally show a snackbar or alert dialog with the error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authResponse.message ?? 'Error during signup'),
                action: SnackBarAction(
                  label: 'Retry', // Button label (optional)
                  onPressed: () {
                    // Define what the button should do
                    // For example, you could re-trigger the signup or something else
                  },
                ),
              ),
            );
          }
        } else if (state is Signupwithgooglenavigate) {
          final authResponse = await GoogleSigninFirebase.googleSignIn();
          if (authResponse.success) {
            // Show a floating snackbar for Google sign-in success
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You have logged in with Google'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to MainScreen or any appropriate screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return MainScreen();
              }),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authResponse.message ?? 'Google Sign-In failed'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        if (state is UserSucessState) {
          return SingleChildScrollView(
            child: Expanded(
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: MyTextField(
                            controller: emailController,
                            hintText: 'Email',
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(CupertinoIcons.mail_solid),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please fill in this field';
                              } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                  .hasMatch(val)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            }),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: MyTextField(
                            controller: passwordController,
                            hintText: 'Password',
                            obscureText: obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            prefixIcon: const Icon(CupertinoIcons.lock_fill),
                            onChanged: (val) {
                              if (val!.contains(RegExp(r'[A-Z]'))) {
                                setState(() {
                                  containsUpperCase = true;
                                });
                              } else {
                                setState(() {
                                  containsUpperCase = false;
                                });
                              }
                              if (val.contains(RegExp(r'[a-z]'))) {
                                setState(() {
                                  containsLowerCase = true;
                                });
                              } else {
                                setState(() {
                                  containsLowerCase = false;
                                });
                              }
                              if (val.contains(RegExp(r'[0-9]'))) {
                                setState(() {
                                  containsNumber = true;
                                });
                              } else {
                                setState(() {
                                  containsNumber = false;
                                });
                              }
                              if (val.contains(RegExp(
                                  r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                                setState(() {
                                  containsSpecialChar = true;
                                });
                              } else {
                                setState(() {
                                  containsSpecialChar = false;
                                });
                              }
                              if (val.length >= 8) {
                                setState(() {
                                  contains8Length = true;
                                });
                              } else {
                                setState(() {
                                  contains8Length = false;
                                });
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                  if (obscurePassword) {
                                    iconPassword =
                                        CupertinoIcons.eye_slash_fill;
                                  } else {
                                    iconPassword = CupertinoIcons.eye_fill;
                                  }
                                });
                              },
                              icon: Icon(iconPassword),
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please fill in this field';
                              } else if (!RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                  .hasMatch(val)) {
                                return 'Please enter a valid password';
                              }
                              return null;
                            }),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "⚈  1 uppercase",
                                style: TextStyle(
                                    color: containsUpperCase
                                        ? Colors.green
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                              ),
                              Text(
                                "⚈  1 lowercase",
                                style: TextStyle(
                                    color: containsLowerCase
                                        ? Colors.green
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                              ),
                              Text(
                                "⚈  1 number",
                                style: TextStyle(
                                    color: containsNumber
                                        ? Colors.green
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "⚈  1 special character",
                                style: TextStyle(
                                    color: containsSpecialChar
                                        ? Colors.green
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                              ),
                              Text(
                                "⚈  8 minimum character",
                                style: TextStyle(
                                    color: contains8Length
                                        ? Colors.green
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: MyTextField(
                            controller: nameController,
                            hintText: 'Name',
                            obscureText: false,
                            keyboardType: TextInputType.name,
                            prefixIcon: const Icon(CupertinoIcons.person_fill),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please fill in this field';
                              } else if (val.length > 30) {
                                return 'Name too long';
                              }
                              return null;
                            }),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      !signUpRequired
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: TextButton(
                                  onPressed: () {
                                    tryvalidate();
                                    userbloc.add(UserSignupButtonPressed(
                                        email: emailController.text.trim(),
                                        pssword: passwordController.text.trim(),
                                        name: nameController.text.trim()));
                                  },
                                  style: TextButton.styleFrom(
                                      elevation: 3.0,
                                      backgroundColor: Colors.teal,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60))),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 5),
                                    child: Text(
                                      'Sign Up',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                            )
                          : const CircularProgressIndicator(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.green,
                              indent: 20,
                              endIndent: 10,
                            ),
                          ),
                          Text(
                            "Sign Up with",
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.green,
                              indent: 10,
                              endIndent: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              userbloc.add(Signupwithgoogleclicked());
                              // Handle Google login
                            },
                            icon: Image.asset(
                              'images/ph1.png', // Replace with your Google icon asset path
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }
}
