import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/colors.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/admin/admin_setting_screen/admin_edit_screen.dart';
import 'package:drawer/screens/admin/admin_setting_screen/all_user_details.dart';
import 'package:drawer/screens/users/Home_Screen/home.dart';
import 'package:drawer/screens/users/login_register/loginpage.dart';
import 'package:drawer/screens/users/login_register/registerpage.dart';
import 'package:drawer/services/auth_hepler.dart';
import 'package:drawer/services/firestore_services.dart';
import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestoreService.getUser(currentUser?.uid ?? ''),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          }

          // Check if no data is available
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No data available for this user",
                style: TextStyle(color: darkFontGrey, fontSize: 16),
              ),
            );
          }

          // Fetch the first document
          var data = snapshot.data!.docs[0];
          return Scaffold(
            backgroundColor: Colors.deepPurple[900],
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                'Settings',
                style: TextStyle(fontSize: 16.0, color: whiteColor),
              ),
              actions: [
                if (currentUser != null) ...[
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AdminEditScreen(data: data)));
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: whiteColor,
                      )),
                  TextButton(
                    onPressed: () async {
                      await AuthenticationHelper().logoutUser(context);
                      setState(() {
                        currentUser = null; // User session clear
                      });
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                ] else ...[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterPage())); // Ensure RegisterPage exists
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                ]
              ],
            ),
            body: Column(
              children: [
                ListTile(
                  leading: data['imageurl'] == null || data['imageurl'] == ''
                      ? ClipOval(
                          child: Image.asset(
                            imgS1,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipOval(
                          child: Image.memory(
                            base64Decode(data['imageurl']),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                  title: Text(
                    "${data['name'] ?? 'No Name'}",
                    style: const TextStyle(color: whiteColor, fontFamily: bold),
                  ),
                  subtitle: Text("${data['email'] ?? 'No Email'}",
                      style: const TextStyle(
                          color: whiteColor, fontFamily: semibold)),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0), // Slightly more padding
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    elevation: 4, // Soft shadow effect
                    color: whiteColor, // Dark background for contrast
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(Icons.verified_user_rounded,
                            color: Colors.white),
                      ),
                      title: const Text(
                        "All Users",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 18,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllUserDetails(),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
