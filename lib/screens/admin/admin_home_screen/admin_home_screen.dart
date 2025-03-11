import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/admin/admin_product_screen/admin_product_details.dart';
import 'package:drawer/screens/admin/admin_widget/dashboard_button.dart';
import 'package:drawer/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          automaticallyImplyLeading: false,
          title: const Text(
            'Dashboard',
            style:
                TextStyle(fontFamily: bold, fontSize: 16, color: darkFontGrey),
          ),
          actions: [
            Text(intl.DateFormat('EEE, MMM d,' 'yy ').format(DateTime.now()))
          ],
        ),
        body: FutureBuilder(
            future: firestoreService.getFeaturedProducts(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: Text("No  products available"));
              }

              var allProducts = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.all(8),
                child: FutureBuilder(
                  future: firestoreService.getAdminCount(),
                  builder: (context, AsyncSnapshot adminSnapshot) {
                    if (adminSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (adminSnapshot.hasError) {
                      return const Center(child: Text("Error loading data"));
                    }
                    var coutData = adminSnapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dashboard Buttons Row 1
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            dashboardButton(
                              context,
                              title: 'Products',
                              count: coutData[2].toString(),
                              icon: icProducts,
                            ),
                            dashboardButton(
                              context,
                              title: 'Orders',
                              count: coutData[0].toString(),
                              icon: icOrders,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Dashboard Buttons Row 2
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            dashboardButton(
                              context,
                              title: 'Total Sales',
                              count: "Rs: ${coutData[3].toString()}",
                              icon: icWholeSale,
                            ),
                            dashboardButton(
                              context,
                              title: 'Wishlist',
                              count: coutData[1].toString(),
                              icon: icAdd,
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 10),

                        // Popular Products Title
                        const Text(
                          'Popular Products',
                          style: TextStyle(
                              fontFamily: bold,
                              fontSize: 20.0,
                              color: darkFontGrey),
                        ),
                        const SizedBox(height: 10),

                        // Product List
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: allProducts.length,
                            itemBuilder: (context, index) {
                              var product = allProducts[index];

                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AdminProductDetails(
                                          title: "${product['p_name']}",
                                          data: product,
                                        ),
                                      ),
                                    );
                                  },
                                  leading: Image.memory(
                                    base64Decode(product['p_image']),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(
                                    "${product['p_name']}",
                                    style: const TextStyle(
                                        color: fontGrey, fontFamily: bold),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        "Rs: ${product['p_price']}",
                                        style: const TextStyle(
                                            fontFamily: semibold,
                                            color: darkFontGrey),
                                      ),
                                      const SizedBox(width: 20),
                                      const Text(
                                        "Featured",
                                        style: TextStyle(
                                            fontFamily: semibold,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }));
  }
}
