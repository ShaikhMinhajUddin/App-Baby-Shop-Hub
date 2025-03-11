import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/colors.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/users/user_widget/custom_form.dart';
import 'package:drawer/services/auth_hepler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminEditScreen extends StatefulWidget {
  final dynamic data;
  const AdminEditScreen({super.key, this.data});

  @override
  State<AdminEditScreen> createState() => _AdminEditScreenState();
}

class _AdminEditScreenState extends State<AdminEditScreen> {
  Uint8List? profileImageWeb;
  String? profileImagePath;
  bool isLoading = false;

  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.data["name"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteColor),
        title: const Text(
          'Edit Admin Details',
          style: TextStyle(fontSize: 16.0, color: whiteColor),
        ),
        actions: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: whiteColor),
                  ),
                  onPressed: () => updateUserDetails(context),
                  child: const Text(
                    'Save Details',
                    style: TextStyle(
                      fontFamily: semibold,
                      color: whiteColor,
                    ),
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: profileImageWeb != null
                    ? Image.memory(profileImageWeb!,
                        width: 80, height: 80, fit: BoxFit.cover)
                    : profileImagePath != null
                        ? Image.file(File(profileImagePath!),
                            width: 80, height: 80, fit: BoxFit.cover)
                        : Image.memory(base64Decode(widget.data['imageurl']),
                            width: 80, height: 80, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await changeImage();
                  await updateProfileImage(); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(150, 50),
                ),
                child: const Text('Change Image',
                    style: TextStyle(color: whiteColor)),
              ),
              const Divider(),
              const SizedBox(height: 20),
              CustomTextField(
                  label: 'Name',
                  hint: 'Change Name',
                  ispass: false,
                  controller: nameController),
              CustomTextField(
                  label: 'Password',
                  hint: 'Old Password',
                  ispass: true,
                  controller: oldpassController),
              CustomTextField(
                  label: 'Password',
                  hint: 'New Password',
                  ispass: true,
                  controller: newPassController),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateProfileImage() async {
    try {
      if ((kIsWeb && profileImageWeb == null) ||
          (!kIsWeb && profileImagePath == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content:
                Text('Please select an image', style: TextStyle(fontSize: 18)),
          ),
        );
        return;
      }

      setState(() {
        isLoading = true;
      });

      String base64image;
      if (kIsWeb) {
        base64image = base64Encode(profileImageWeb!);
      } else {
        base64image = base64Encode(File(profileImagePath!).readAsBytesSync());
      }

      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(currentUser!.uid)
          .update({"imageurl": base64image});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Profile image updated successfully!',
              style: TextStyle(fontSize: 18)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to update image: $e',
              style: const TextStyle(fontSize: 18)),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateUserDetails(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (widget.data['password'] == oldpassController.text) {
        await AuthenticationHelper().changeAuthPassword(
            email: widget.data['email'],
            password: oldpassController.text,
            newpassword: newPassController.text);

        await FirebaseFirestore.instance
            .collection(userCollection)
            .doc(currentUser!.uid)
            .update({
          "name": nameController.text,
          "password": newPassController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('User details updated successfully!',
                style: TextStyle(fontSize: 18)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Wrong password', style: TextStyle(fontSize: 18)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to update details: $e',
              style: const TextStyle(fontSize: 18)),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> changeImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      if (kIsWeb) {
        profileImageWeb = await pickedFile.readAsBytes();
      } else {
        profileImagePath = pickedFile.path;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void notifyListeners() {}
}
