import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drawer/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationHelper {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription<User?>? authSubscription;

  Future<UserCredential?> signIn({email, password}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      e.toString();
    }
    return userCredential;
  }

  Future<UserCredential?> signUp({
    email,
    password,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      e.toString();
    }
    return userCredential;
  }

  storeUserData({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String role,
  }) async {
    final user = auth.currentUser;
    if (user == null) return;

    DocumentReference store =
        firestore.collection(userCollection).doc(user.uid);

    DocumentSnapshot doc = await store.get();

    if (!doc.exists) {
      await store.set({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address,
        'role': role,
        'id': user.uid,
        'imageurl': '',
        'cart_count': "00",
        'wishlist_count': "00",
        'order_count': "00",
      });
    }
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error) {
      error.toString();
    });
  }

  Future<void> logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    currentUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
