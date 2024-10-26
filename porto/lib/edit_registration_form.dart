// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:porto/home.dart';

class UserProfileSetup extends StatefulWidget {
  const UserProfileSetup({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserProfileSetupState createState() => _UserProfileSetupState();
}

class _UserProfileSetupState extends State<UserProfileSetup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _workexperienceController =
      TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();

  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData().then((userData) {
      if (userData != null) {
        _roleController.text = userData['role'] ?? '';
        _addressController.text = userData['address'] ?? '';
        _mobileController.text = userData['mobile'] ?? '';
        _descriptionController.text = userData['description'] ?? '';
        _educationController.text = userData['education'] ?? '';
        _skillsController.text = userData['skills'] ?? '';
        _workexperienceController.text = userData['workExperience'] ?? '';
        _hobbiesController.text = userData['hobbies'] ?? '';
        _instagramController.text = userData['instagramHandle'] ?? '';
      }
    });
  }

  @override
  void dispose() {
    _roleController.dispose();
    _addressController.dispose();
    _mobileController.dispose();
    _descriptionController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    _workexperienceController.dispose();
    _hobbiesController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('userDetails')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        return doc.data();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/details.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Column(
            children: [
              Container(
                height: screenHeight * 0.39,
                width: double.infinity,
                color: Colors.transparent,
                padding: EdgeInsets.fromLTRB(25, screenHeight * 0.085, 25, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 56,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: _imageFile != null
                                  ? Image.file(
                                      _imageFile!,
                                      fit: BoxFit.cover,
                                      width: 110,
                                      height: 110,
                                    )
                                  : Image.asset(
                                      'assets/user.png',
                                      fit: BoxFit.cover,
                                      width: 110,
                                      height: 110,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<String>(
                      future: getName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('');
                        } else {
                          final name = snapshot.data?.trim() ?? '';
                          final firstName = name.split(' ').first;
                          return Text(
                            'Welcome $firstName!',
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Please fill all the details below for your portfolio.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _roleController,
                            hintText: 'Enter your role',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your role';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _mobileController,
                            hintText: 'Enter your mobile number',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your mobile number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _descriptionController,
                            hintText: 'Add personal description',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please add a personal description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _addressController,
                            hintText: 'Enter your address',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _educationController,
                            hintText: 'Add details about your education',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please add your education details';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _skillsController,
                            hintText: 'Add your skills',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please add some skills';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _workexperienceController,
                            hintText: 'Tell us about your work experience',
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _hobbiesController,
                            hintText: 'Enter your hobbies',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some hobbies';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: _instagramController,
                            hintText: 'Add your instagram handle',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please add your instagram handle';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(26),
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        await saveUserProfileDetails(
                          role: _roleController.text.trim(),
                          mobile: _mobileController.text.trim(),
                          description: _descriptionController.text.trim(),
                          address: _addressController.text.trim(),
                          education: _educationController.text.trim(),
                          skills: _skillsController.text.trim(),
                          workExperience: _workexperienceController.text.trim(),
                          hobbies: _hobbiesController.text.trim(),
                          instagramHandle: _instagramController.text.trim(),
                          imageFile: _imageFile,
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 50),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const ProfilePage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              final tween = Tween(begin: begin, end: end);
                              final offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF46c6d4),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      minLines: 1,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 15,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

Future<String> getName() async {
  final user = FirebaseAuth.instance.currentUser!;
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return doc.data()!['name'];
}

Future<void> saveUserProfileDetails({
  required String role,
  required String mobile,
  required String description,
  required String address,
  required String education,
  required String skills,
  String? workExperience,
  required String hobbies,
  required String instagramHandle,
  File? imageFile,
}) async {
  try {
    final User user = FirebaseAuth.instance.currentUser!;
    String? imageUrl;

    if (imageFile != null) {
      try {
        // Upload the profile image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profiles/${user.uid}/profile_image.jpg');
        final uploadTask = await storageRef.putFile(imageFile);

        // Get the download URL of the uploaded image
        imageUrl = await uploadTask.ref.getDownloadURL();
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('userDetails')
        .doc(user.uid);

    await userDoc.update({
      'role': role,
      'mobile': mobile,
      'description': description,
      'address': address,
      'education': education,
      'skills': skills,
      'workExperience': workExperience,
      'hobbies': hobbies,
      'instagramHandle': instagramHandle,
      if (imageUrl != null) 'profileImageUrl': imageUrl,
    });

    print("User profile details saved or updated successfully.");
  } catch (e) {
    print("Error saving or updating user profile details: $e");
  }
}
