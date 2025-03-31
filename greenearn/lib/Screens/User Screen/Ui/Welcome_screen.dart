import 'package:flutter/material.dart';
import 'package:greenearn/Screens/User%20Screen/Ui/Sign_in.dart';
import 'package:greenearn/Screens/User%20Screen/Ui/Sign_up.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome message
            const SizedBox(height: 20), // Top padding
            Text(
              '👋 Welcome Back!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700, // Sustainable green color
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Join us on a journey towards sustainability with Plasto!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.green.shade400.withOpacity(0.8), // Earthy tone
                ),
              ),
            ),
            const SizedBox(height: 40), // Space before TabBar and TabBarView

            // TabBar and TabBarView section
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.6, // Adjust height for better visual balance
              child: Column(
                children: [
                  // TabBar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TabBar(
                      controller: tabController,
                      unselectedLabelColor: Colors.green.shade400
                          .withOpacity(0.5), // Subtle green for inactive tabs
                      labelColor: Colors.green.shade700, // Highlight active tab
                      indicatorColor: Colors.green.shade700,
                      indicatorWeight: 4.0,
                      tabs: const [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TabBarView
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: const [
                        SignIn(),
                        SignUp(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
