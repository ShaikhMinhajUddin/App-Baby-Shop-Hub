import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/admin/admin_home_screen/admin_home_screen.dart';
import 'package:drawer/screens/admin/admin_orders_screen/admin_order_screen.dart';
import 'package:drawer/screens/admin/admin_product_screen/admin_products_screen.dart';
import 'package:drawer/screens/admin/admin_setting_screen/admin_settings_screen.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
   var navListItem = [
     BottomNavigationBarItem(icon: Image.asset(icHome,width: 25,color: Colors.black,), label: 'Dashboard'),
     BottomNavigationBarItem(icon: Image.asset(icProducts,width: 25), label: 'Products'),
     BottomNavigationBarItem(icon: Image.asset(icOrders,width: 25), label: 'Orders'),
     BottomNavigationBarItem(icon: Image.asset(icGenreralSettings,width: 25), label: 'Settings'),
  ];

  var navBody = [
   AdminHomeScreen(),
   AdminProductsScreen(),
   AdminOrderScreen(),
   AdminSettingsScreen()
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