import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenearn/Screens/Home%20Screen/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenearn/Screens/User%20Screen/Ui/Welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenearn/Screens/main_screen/UI/main_screen.dart';

class HomeLoadingScreen extends StatefulWidget {
  const HomeLoadingScreen({super.key});

  @override
  State<HomeLoadingScreen> createState() => _HomeLoadingScreenState();
}

class _HomeLoadingScreenState extends State<HomeLoadingScreen> {
  final HomeBloc homebloc = HomeBloc();

  @override
  void initState() {
    super.initState();

    // Check if the user is logged in before proceeding
    _checkLoginStatus();
  }

  // Function to check user login status
  void _checkLoginStatus() async {
    // Make sure FirebaseAuth is initialized before using it
    await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser; // Check the current user

    if (user != null) {
      // If the user is logged in, navigate directly to the main screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MainScreen();
      }));
    } else {
      // If not logged in, proceed to loading screen logic
      homebloc.add(HomeInitialEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homebloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeGetStartedNavigate) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const WelcomeScreen();
          }));
        }
      },
      builder: (context, state) {
        if (state is HomeSucessState) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 250),
                    height: 250,
                    width: 330,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      "Building sustainable solutions for a greener tomorrow.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      homebloc.add(HomeGetStartedButtonPressed());
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.only(top: 85),
                    child: Text(
                      "A Product by Chang",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        letterSpacing: 1.2,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Add fallback UI here if necessary
          return const Scaffold(
            body: Center(
              child: Text("Loading... Please wait."),
            ),
          );
        }
      },
    );
  }
}
