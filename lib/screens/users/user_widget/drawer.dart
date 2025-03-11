// import 'package:drawer/services/auth_hepler.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserDrawer extends StatelessWidget {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   Future<Map<String, dynamic>?> _getUserDetails() async {
//     try {
//       User? user = auth.currentUser;
//       if (user != null) {
//         DocumentSnapshot userDoc = await firestore.collection("users").doc(user.uid).get();
//         return userDoc.data() as Map<String, dynamic>?;
//       }
//       return null;
//     } catch (e) {
//       print("Error fetching user details: $e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: FutureBuilder<Map<String, dynamic>?>(
//         future: _getUserDetails(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return const Center(child: Text('Error fetching user details.'));
//           }

//           if (snapshot.hasData) {
//             final userDetails = snapshot.data;
//             final String name = userDetails?['name'] ?? 'Guest';
//             final String email = userDetails?['email'] ?? 'No email';

//             return ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _buildDrawerHeader(name, email),
//                 _buildListTile(
//                   context,
//                   title: 'Update Profile',
//                   icon: Icons.person,
//                   onTap: () {}
//                   // Navigator.pushNamed(context, PageRoutes.profilesetting),
//                 ),
//                 _buildListTile(
//                   context,
//                   title: 'Logout',
//                   icon: Icons.logout,
//                   onTap: () async {
//                     await AuthenticationHelper().signOut();
//                     Navigator.pop(context);
//                     // Navigator.pushNamed(context, PageRoutes.loginpage);
//                   },
//                 ),
//               ],
//             );
//           }

//           return const Center(child: Text('No user found.'));
//         },
//       ),
//     );
//   }

//   Widget _buildDrawerHeader(String name, String email) {
//     return DrawerHeader(
//       decoration: const BoxDecoration(
//         color: Colors.redAccent,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const CircleAvatar(
//             radius: 40,
//             backgroundColor: Colors.white,
//             child: Icon(Icons.person, size: 40, color: Colors.blue),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             name,
//             style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             email,
//             style: const TextStyle(color: Colors.white70, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildListTile(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.redAccent),
//       title: Text(title, style: const TextStyle(fontSize: 16)),
//       onTap: onTap,
//     );
//   }
// }
