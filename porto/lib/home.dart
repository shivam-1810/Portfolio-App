import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:porto/edit_registration_form.dart';
import 'package:porto/splash_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>?> fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('userDetails')
          .doc(user.uid)
          .get();
      return doc.data();
    }
    return null;
  }

  Future<String> getMail() async {
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return doc.data()!['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile data'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No profile data available'));
          }

          final userData = snapshot.data!;
          final workExperience = userData['workExperience'] as String?;
          final profileImage =
              userData['profileImageUrl'] as String? ?? 'assets/user.png';

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/finalpage.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              Positioned.fill(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.13,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromARGB(255, 56, 172, 185),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 85,
                          backgroundImage: profileImage.startsWith('http')
                              ? NetworkImage(profileImage)
                              : AssetImage(profileImage) as ImageProvider,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.155),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            FutureBuilder<String>(
                              future: getName(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  final name = snapshot.data!.trim();
                                  return Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              userData['role'] ?? 'UI/UX Designer',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 20),
                            ProfileSection(
                              title: 'Personal Description',
                              content: userData['description'] ?? '',
                            ),
                            ProfileSection(
                              title: 'Education',
                              content: userData['education'] ?? '',
                            ),
                            ProfileSection(
                              title: 'Skills',
                              content: userData['skills'] ?? '',
                            ),
                            ProfileSection(
                              title: 'Hobbies',
                              content: userData['hobbies'] ?? '',
                            ),
                            if (workExperience != null &&
                                workExperience.isNotEmpty)
                              ProfileSection(
                                title: 'Work Experience',
                                content: workExperience,
                              ),
                            FutureBuilder<String>(
                              future: getMail(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  final mail = snapshot.data!.trim();
                                  return ProfileSection(
                                    title: 'Contact Details',
                                    content: '- Email : $mail\n'
                                        '- Mobile : ${userData['mobile']}\n'
                                        '- Instagram : ${userData['instagramHandle']}\n'
                                        '- Address : ${userData['address']}',
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 15),
                            _buildButton(context, 'Edit Details', () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 50),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const UserProfileSetup(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    final tween = Tween(begin: begin, end: end);
                                    final offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            }),
                            const SizedBox(height: 15),
                            _buildButton(context, 'Log Out', () async {
                              await FirebaseAuth.instance.signOut();
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushAndRemoveUntil(
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 50),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SplashScreen(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    final tween = Tween(begin: begin, end: end);
                                    final offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                                (Route<dynamic> route) => false,
                              );
                            }),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.89,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF46c6d4),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String title;
  final String content;

  const ProfileSection({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
