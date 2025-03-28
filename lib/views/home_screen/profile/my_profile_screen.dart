import 'package:eat_fit/views/home_screen/profile/about_us_screen.dart';
import 'package:eat_fit/views/home_screen/profile/contact_us_screen.dart';
import 'package:eat_fit/views/home_screen/profile/edit_profile.dart';
import 'package:eat_fit/views/splash_screen/first_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const FirstSplashScreen(),
      ),
      (route) => false, // Disable back feature
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: uid == null
          ? const Center(child: Text("User not logged in"))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("No user data found"));
                }

                final userDoc = snapshot.data!;
                final profileImageUrl =
                    userDoc.get('profileImageUrl') as String?;
                final firstName = userDoc.get('firstName') as String?;
                final lastName = userDoc.get('lastName') as String?;

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Picture
                      GestureDetector(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: profileImageUrl != null &&
                                  profileImageUrl.isNotEmpty
                              ? NetworkImage(profileImageUrl)
                              : const AssetImage('assets/images/profile.jpg')
                                  as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(
                        "$firstName $lastName",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Edit Profile Button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EditProfileScreen()),
                          );
                        },
                        child: Container(
                          width: 328,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF35CC8C),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Icon(Icons.edit, color: Colors.white, size: 24),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Divider(color: Colors.grey, thickness: 1),
                      const SizedBox(height: 20),

                      // Options: Contact Us, About Us, Log Out
                      buildOptionRow(
                        icon: 'assets/icons/email.png',
                        text: "Contact Us",
                        textColor: Colors.black,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ContactUsScreen(),
                            ),
                          );
                          // Handle contact us
                        },
                      ),
                      const SizedBox(height: 16),
                      buildOptionRow(
                        icon: 'assets/icons/about.png',
                        text: "About Us",
                        textColor: Colors.black,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutUsScreen(),
                            ),
                          );
                          // Handle about us
                        },
                      ),

                      const SizedBox(height: 16),
                      buildOptionRow(
                        icon: 'assets/icons/logout.png',
                        text: "Log Out",
                        textColor:
                            const Color(0xFFCB2030), // Red color for log out
                        onTap: () => logout(context), // Logout function
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget buildOptionRow({
    required String icon,
    required String text,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error,
                  size: 24, color: Colors.red); // Fallback if image fails
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
