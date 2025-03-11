import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/users/Cart_Screen/cart_screen.dart';
import 'package:drawer/screens/users/Category_Screen.dart/category_screen.dart';
import 'package:drawer/screens/users/Home_Screen/home_screen.dart';
import 'package:drawer/screens/users/profile_Screen/profile_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var navListItem = [
     BottomNavigationBarItem(icon: Image.asset(icHome,width: 25), label: 'Home'),
     BottomNavigationBarItem(icon: Image.asset(icCategories,width: 25), label: 'category'),
     BottomNavigationBarItem(icon: Image.asset(icCart,width: 25), label: 'Cart'),
     BottomNavigationBarItem(icon: Image.asset(icProfile,width: 25), label: 'Profile'),
  ];

  var navBody = [
   HomeScreen(),
   CategoryScreen(),
   CartScreen(),
   ProfileScreen()
  ];

  int currentNavIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: navBody.elementAt(currentNavIndex)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentNavIndex,
        items: navListItem,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        onTap: (value) {
          setState(() {
          currentNavIndex= value;
          });
        },
      ),
    );
  }
}
