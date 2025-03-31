import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenearn/FirebaseFunctions/Auth.dart';
import 'package:greenearn/Screens/User%20Screen/Ui/ForgotPassword.dart';
import 'package:greenearn/Screens/User%20Screen/Ui/MyText.dart';
import 'package:greenearn/Screens/User%20Screen/bloc/user_bloc.dart';
import 'package:greenearn/Screens/main_screen/UI/main_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

final UserBloc userbloc = UserBloc();

class _SignInState extends State<SignIn> {
  void tryvalidate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      print("Validation Failed");
    }
  }

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_slash_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  void initState() {
    userbloc.add(UserInititialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      bloc: userbloc,
      listenWhen: (previous, current) => current is UserActionState,
      buildWhen: (previous, current) => current is! UserActionState,
      listener: (context, state) async {
        if (state is UserSigninAuthState) {
          final authResponse =
              await SigninFirebase.signin(state.email, state.pssword);
          if (authResponse.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return MainScreen();
              }),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authResponse.message ?? 'Error during signup'),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {},
                ),
              ),
            );
          }
        } else if (state is ForgotPasswordNavigate) {
          Navigator.push(context, MaterialPageRoute(builder: (cntext) {
            return const ForgotPassword();
          }));
        } else if (state is Signinwithgooglenavigate) {
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
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MainScreen();
            }));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Google Sign-In failed'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        if (state is UserSucessState) {
          return Expanded(
            child: Form(
                key: _formKey,
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
                            errorMsg: _errorMsg,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please fill in this field';
                              } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                  .hasMatch(val)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            })),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: obscurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(CupertinoIcons.lock_fill),
                        errorMsg: _errorMsg,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (!RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                              .hasMatch(val)) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                              if (obscurePassword) {
                                iconPassword = CupertinoIcons.eye_slash_fill;
                              } else {
                                iconPassword = CupertinoIcons.eye_fill;
                              }
                            });
                          },
                          icon: Icon(iconPassword),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 23),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            userbloc.add(ForgotPasswordClicked());
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    !signInRequired
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextButton(
                                onPressed: () {
                                  tryvalidate();
                                  userbloc.add(UserSinginButtonPressed(
                                      email: emailController.text.trim(),
                                      pssword: passwordController.text.trim()));
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
                                    'Sign In',
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
                      height: 30,
                    ),
                    // Divider with "Login with"
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
                          "Sign In with",
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
                            userbloc.add(Signinwithgoogleclicked());
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
                )),
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }
}
