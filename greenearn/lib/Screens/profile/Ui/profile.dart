import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greenearn/Screens/Home%20Screen/Ui/Home_loading_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> _logout() async {
    try {
      // Sign out from Firebase and Google
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().disconnect();

      // Navigate to the Home Loading Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeLoadingScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully logged out.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during sign-out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.05,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Text and Edit Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 24),
                  onPressed: () {
                    // Navigate to edit shop profile page
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Shop Logo and Name
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150', // Replace with shop logo URL
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "ABC Shop", // Replace with shop name
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Chennai, India", // Replace with shop location
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Shop Statistics (Total Transactions, Pending Orders, Total Credit Given)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(screenWidth, "Transactions", "120"),
                _buildStatCard(screenWidth, "Pending Orders", "8"),
                _buildStatCard(screenWidth, "Total Credit Given", "1500"),
              ],
            ),
            const SizedBox(height: 20),

            // Shop Details
            _buildDetailsCard(
              title: "Shop Details",
              details: [
                _buildDetailRow("GST Number", "33XXXXXXXXXXXXX"),
                _buildDetailRow("Address", "123 Main Street, Chennai"),
                _buildDetailRow("Contact", "+91 9876543210"),
                _buildDetailRow("Email", "shop@example.com"),
              ],
            ),
            const SizedBox(height: 20),

            // Options List
            Column(
              children: [
                _buildOption(
                  icon: Icons.inventory,
                  title: "Manage Inventory",
                  onTap: () {
                    // Navigate to inventory management
                  },
                ),
                _buildOption(
                  icon: Icons.logout,
                  title: "Logout",
                  onTap: _logout,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(double screenWidth, String title, String value) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: screenWidth * 0.25, // Use double for width calculation
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Align text vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title, // Title on top
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard(
      {required String title, required List<Widget> details}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...details,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
