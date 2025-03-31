import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenearn/FirebaseFunctions/Auth.dart';
import 'package:greenearn/Screens/User%20Screen/Ui/MyText.dart';
import 'package:greenearn/Screens/User%20Screen/Ui/Sign_in.dart';
import 'package:greenearn/Screens/User%20Screen/bloc/user_bloc.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMsg;
  bool isProcessing = false;

  void try_validate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      print("Validation Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      bloc: userbloc,
      listenWhen: (previous, current) => current is UserActionState,
      buildWhen: (previous, current) => current is! UserActionState,
      listener: (context, state) async {
        if (state is ResetPasswordnavigate) {
          setState(() {
            isProcessing = true;
          });

          // Call Firebase password reset
          final authResponse =
              await PasswordResetFirebase.resetPassword(state.email);

          setState(() {
            isProcessing = false;
          });

          if (authResponse.success) {
            // Show SnackBar indicating success
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                    'Password reset link has been sent to your email.'),
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );

            // Navigate to SignIn screen
            Navigator.pop(context); // Close the current screen
          } else {
            // Show error message if there is a failure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(authResponse.message ?? 'Error during password reset'),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {},
                ),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Forgot Password')),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center content
                children: [
                  const SizedBox(height: 20),
                  // Instruction Text
                  const Text(
                    'Once you enter your email, click "Reset Password" and check your email for the reset link.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: MyTextField(
                      controller: emailController,
                      hintText: 'Enter your email',
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(CupertinoIcons.mail_solid),
                      errorMsg: _errorMsg,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                            .hasMatch(val)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  isProcessing
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.8, // Adjust width to fit in one line
                          child: TextButton(
                              onPressed: () {
                                try_validate();
                                userbloc.add(ResetPasswordclicked(
                                    email: emailController.text.trim()));
                              },
                              style: TextButton.styleFrom(
                                  elevation: 3.0,
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60))),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                                child: Text(
                                  'Reset Password',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
