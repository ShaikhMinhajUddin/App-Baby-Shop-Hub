import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:drawer/consts/colors.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/services/firestore_services.dart';

class AllUserDetails extends StatelessWidget {
  const AllUserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestoreService.getAllUser(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No data available for this user",
                style: TextStyle(color: darkFontGrey, fontSize: 16),
              ),
            );
          }

          // Admin ko exclude karne ke liye filter
          var data = snapshot.data!.docs.where((user) => user['role'] != 'Admin').toList();

          return Scaffold(
            backgroundColor: Colors.deepPurple[900],
            appBar: AppBar(
              iconTheme: const IconThemeData(color: whiteColor),
              title: const Text(
                'All Users',
                style: TextStyle(fontSize: 16.0, color: whiteColor),
              ),
            ),
            body: data.isEmpty
                ? const Center(
                    child: Text(
                      "No users available",
                      style: TextStyle(color: whiteColor, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var user = data[index];
                      String imageUrl = user['imageurl'] ?? ''; // Handle null values

                      return Card(
                        child: ListTile(
                          leading: ClipOval(
                            child: imageUrl.isNotEmpty && isBase64(imageUrl)
                                ? Image.memory(
                                    base64Decode(imageUrl),
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  )
                                : Image.network(
                                    imgS1, // Default image
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                          ),
                          title: Text(user['name'] ?? "No Name"),
                          subtitle: Text(user['email'] ?? "No Email"),
                          onTap: () => showUserDetails(context, user),
                        ),
                      );
                    },
                  ),
          );
        });
  }

  // Function to check if a string is Base64
  bool isBase64(String str) {
    return RegExp(r'^[A-Za-z0-9+/]+={0,2}$').hasMatch(str);
  }

  void showUserDetails(BuildContext context, DocumentSnapshot data) {
    String imageUrl = data['imageurl'] ?? ''; // Handle null
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(data['name'] ?? "Unknown")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: imageUrl.isNotEmpty && isBase64(imageUrl)
                    ? Image.memory(
                        base64Decode(imageUrl),
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      )
                    : Image.network(
                        imgS1, // Default image
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
              ),
              const SizedBox(height: 10),
              Text("📧 Email: ${data['email'] ?? 'N/A'}"),
              Text("📍 Address: ${data['address'] ?? 'N/A'}"),
              Text("📞 Phone: ${data['phone'] ?? 'N/A'}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
