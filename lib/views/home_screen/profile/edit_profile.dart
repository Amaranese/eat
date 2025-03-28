import 'package:eat_fit/controllers/cloudinary_upload.dart';
import 'package:eat_fit/views/home_screen/profile/change_password.dart';
import 'package:eat_fit/views/home_screen/profile/delete_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _profileImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// **Fetch user data from Firebase Firestore**
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        _firstNameController.text = data?['firstName'] ?? '';
        _lastNameController.text = data?['lastName'] ?? '';
        _emailController.text = user.email ?? '';
        _profileImageUrl = data?['profileImageUrl'];
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// **Save updated profile data to Firestore**
  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser!;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")));
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile.")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// **Upload profile picture**
  Future<void> _uploadProfileImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image selected.")),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final file = File(pickedImage.path);
      final cloudinaryService = CloudinaryService();

      // Upload the image to Cloudinary
      final imageUrl = await cloudinaryService.uploadImageToCloudinary(file);

      if (imageUrl != null) {
        // Save the image URL to Firestore
        final user = FirebaseAuth.instance.currentUser!;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'profileImageUrl': imageUrl,
        });

        setState(() {
          _profileImageUrl = imageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Profile picture updated successfully!")),
        );
      } else {
        throw Exception("Cloudinary upload failed");
      }
    } catch (e) {
      print("Error uploading profile image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload profile picture.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Account",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: _profileImageUrl != null
                              ? NetworkImage(
                                  _profileImageUrl!) // If image exists in Firebase Storage
                              : const AssetImage(
                                      '/Users/emilbasnyat/development/UI:UX_Mun/Eat-Fit/assets/images/profile.jpg')
                                  as ImageProvider, // Fallback to default asset
                          child: _profileImageUrl == null
                              ? const Icon(Icons.camera_alt,
                                  color: Colors
                                      .white) // Show camera icon if no image
                              : null,
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: _uploadProfileImage,
                            child: Container(
                              width: 37,
                              height: 37,
                              decoration: BoxDecoration(
                                color: const Color(0xFF35CC8C),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child:
                                  const Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildProfileField("First Name", _firstNameController, true,
                        'assets/icons/name.png'),
                    const SizedBox(height: 10),
                    _buildProfileField("Last Name", _lastNameController, true,
                        'assets/icons/name.png'),
                    const SizedBox(height: 10),
                    _buildProfileField("Email", _emailController, false,
                        'assets/icons/email.png'),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 20),
                    _buildOptionRow(
                      "Change Password",
                      const Color(0xFF35CC8C),
                      'assets/icons/changepass.png',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildOptionRow(
                      "Delete Account",
                      const Color(0xFFCB2030),
                      'assets/icons/delete.png',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeleteAccountScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: _saveProfile,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF35CC8C),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller,
      bool editable, String iconPath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(iconPath, width: 24, height: 24),
            const SizedBox(width: 10),
            Text(label,
                style: const TextStyle(fontSize: 14, color: Colors.black)),
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: TextField(
              controller: controller,
              enabled: editable,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: editable ? const Color(0xFF35CC8C) : Colors.black),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionRow(
      String label, Color color, String iconPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(iconPath, width: 24, height: 24),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 14, color: color)),
        ],
      ),
    );
  }
}
