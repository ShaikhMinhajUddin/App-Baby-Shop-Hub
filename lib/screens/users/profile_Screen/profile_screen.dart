import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/users/Home_Screen/home.dart';
import 'package:drawer/screens/users/login_register/loginpage.dart';
import 'package:drawer/screens/users/login_register/registerpage.dart';
import 'package:drawer/screens/users/orders_screen/orders_screen.dart';
import 'package:drawer/screens/users/profile_Screen/component/card_details.dart';
import 'package:drawer/screens/users/profile_Screen/component/edit_detail.dart';
import 'package:drawer/screens/users/user_widget/beveled_button.dart';
import 'package:drawer/screens/users/user_widget/lish.dart';
import 'package:drawer/services/auth_hepler.dart';
import 'package:drawer/services/firestore_services.dart';
import 'package:drawer/screens/users/user_widget/bg_widget.dart';
import 'package:drawer/screens/users/wishlist_screen/wishlist_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: firestoreService.getUser(currentUser?.uid ?? ''),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            }

            // Agar user data nahi hai, to login/register dikhayein
            if (snapshot.data!.docs.isEmpty || currentUser == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      child: BeveledButton(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                        title: 'Login',
                        width: MediaQuery.of(context).size.width - 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      child: BeveledButton(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                        },
                        title: 'Register',
                        width: MediaQuery.of(context).size.width - 20,
                      ),
                    ),
                  ],
                ),
              );
            }

            // User ka data
            var data = snapshot.data!.docs[0];

            return SafeArea(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDetail(data: data),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    // Agar user logged in hai to profile show karein
                    Row(
                      children: [
                        data['imageurl'] == null || data['imageurl'] == ''
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'] ?? 'No Name',
                                style: const TextStyle(
                                  fontFamily: semibold,
                                  color: whiteColor,
                                ),
                              ),
                              Text(
                                data['email'] ?? 'No Email',
                                style: const TextStyle(color: whiteColor),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: whiteColor),
                          ),
                          onPressed: () async {
                            await AuthenticationHelper().logoutUser(context);
                            setState(() {
                              currentUser = null; 
                            });
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: semibold,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder(
                      future: firestoreService.getCount(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          var countData = snapshot.data;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              cartDetails(
                                count: countData[0].toString(),
                                title: 'In your Cart',
                                width: 120,
                                height: 60,
                              ),
                              cartDetails(
                                count: countData[2].toString(),
                                title: 'In your Order',
                                width: 120,
                                height: 60,
                              ),
                              cartDetails(
                                count: countData[1].toString(),
                                title: 'In Your Wishlist',
                                width: 120,
                                height: 60,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        itemCount: profileButtonList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index >= profileButtonList.length ||
                              index >= profileButtonIcon.length) {
                            return const SizedBox();
                          }
                          return ListTile(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OrdersScreem(),
                                    ),
                                  );
                                  break;
                                case 1:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WishlistScreen(),
                                    ),
                                  );
                                  break;
                                default:
                                  break;
                              }
                            },
                            leading: Image.asset(
                              profileButtonIcon[index],
                              width: 22,
                              color: darkFontGrey,
                            ),
                            title: Text(
                              profileButtonList[index],
                              style: const TextStyle(
                                color: darkFontGrey,
                                fontFamily: semibold,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: lightGrey,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
