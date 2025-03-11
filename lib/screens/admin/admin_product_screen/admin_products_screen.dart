import 'dart:convert';

import 'package:drawer/consts/colors.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/consts/styles.dart';
import 'package:drawer/screens/admin/admin_product_screen/add_product.dart';
import 'package:drawer/screens/admin/admin_product_screen/admin_product_details.dart';
import 'package:drawer/screens/admin/admin_product_screen/update_product.dart';
import 'package:drawer/services/adminproduct_services.dart';
import 'package:drawer/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  var controlller = AdminproductServices();

  List<String> popupmenulist = [
    "Featured",
    "Edit",
    "Deleted",
    "Top Deal's",
    "Flash Sale",
  ];

  List popupmenuIcons = [
    Icons.star, // Featured
    Icons.edit, // Edit
    Icons.delete, // Deleted
    Icons.local_offer, // Top Deal's
    Icons.flash_on, // Flash Sale
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controlller.getcategory();
          controlller.populateCategoryList();

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddProduct()));
        },
        backgroundColor: Colors.deepPurple[900],
        child: const Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Products',
          style: TextStyle(fontFamily: bold, fontSize: 16, color: darkFontGrey),
        ),
        actions: [
          Text(intl.DateFormat('EEE, MMM d,' 'yy ').format(DateTime.now()))
        ],
      ),
      body: StreamBuilder(
        stream: firestoreService.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products available"));
          }

          var allProducts = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: List.generate(
                  allProducts.length,
                  (index) => Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminProductDetails(
                              title: allProducts[index]['p_name'],
                              data: allProducts[index],
                            ),
                          ),
                        );
                      },
                      leading: Image.memory(
                        base64Decode(allProducts[index]['p_image']),
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        "${allProducts[index]['p_name']}",
                        style: const TextStyle(
                          color: fontGrey,
                          fontFamily: bold,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            "Rs: ${allProducts[index]['p_price']}",
                            style: const TextStyle(
                              fontFamily: semibold,
                              color: darkFontGrey,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            allProducts[index]['isFeatured'] == true
                                ? 'Featured'
                                : '',
                            style: const TextStyle(
                                fontFamily: semibold, color: Colors.green),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<int>(
                        onSelected: (int value) {
                          switch (value) {
                            case 0: // Featured
                              if (allProducts[index]['isFeatured'] == true) {
                                controlller
                                    .removeFeatured(allProducts[index].id);
                              } else {
                                controlller.addFeatured(allProducts[index].id);
                              }
                              break;
                            case 1: // Edit
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateProduct(
                                    productId: allProducts[index].id,
                                    productData: allProducts[index].data()
                                        as Map<String, dynamic>,
                                  ),
                                ),
                              );
                              break;
                            case 2: // Delete
                              controlller.removeProduct(allProducts[index].id);
                              break;
                            case 3: // Top Deal's
                              if (allProducts[index]['TodayDeals'] == true) {
                                controlller
                                    .removetodaydeals(allProducts[index].id);
                              } else {
                                controlller
                                    .addtodaydeals(allProducts[index].id);
                              }
                              break;
                            case 4: // Flash Sale
                              if (allProducts[index]['FlashSale'] == true) {
                                controlller
                                    .removeflashsale(allProducts[index].id);
                              } else {
                                controlller.addflashsale(allProducts[index].id);
                              }
                              break;

                            default:
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          // Featured
                          PopupMenuItem<int>(
                            value: 0,
                            child: Row(
                              children: [
                                Icon(
                                  popupmenuIcons[0],
                                  color: allProducts[index]['featured_id'] ==
                                          currentUser!.uid
                                      ? Colors.green
                                      : darkFontGrey,
                                ),
                                const SizedBox(width: 8),
                                Text(allProducts[index]['featured_id'] ==
                                        currentUser!.uid
                                    ? 'Remove Featured'
                                    : popupmenulist[0]),
                              ],
                            ),
                          ),
                          // Edit
                          PopupMenuItem<int>(
                            value: 1,
                            child: Row(
                              children: [
                                Icon(popupmenuIcons[1]),
                                const SizedBox(width: 8),
                                Text(popupmenulist[1]),
                              ],
                            ),
                          ),
                          // Deleted
                          PopupMenuItem<int>(
                            value: 2,
                            child: Row(
                              children: [
                                Icon(popupmenuIcons[2]),
                                const SizedBox(width: 8),
                                Text(popupmenulist[2]),
                              ],
                            ),
                          ),
                          // Top Deal's
                          PopupMenuItem<int>(
                            value: 3,
                            child: Row(
                              children: [
                                Icon(
                                  popupmenuIcons[3],
                                  color:
                                      allProducts[index]['TodayDeals'] == true
                                          ? Colors.green
                                          : darkFontGrey,
                                ),
                                const SizedBox(width: 8),
                                Text(allProducts[index]['TodayDeals'] == true
                                    ? 'Remove Today Deals'
                                    : popupmenulist[3]),
                              ],
                            ),
                          ),
                          // Flash sale
                          PopupMenuItem<int>(
                            value: 4,
                            child: Row(
                              children: [
                                Icon(
                                  popupmenuIcons[4],
                                  color: allProducts[index]['FlashSale'] == true
                                      ? Colors.green
                                      : darkFontGrey,
                                ),
                                const SizedBox(width: 8),
                                Text(allProducts[index]['FlashSale'] == true
                                    ? 'Remove Flash Sale'
                                    : popupmenulist[4]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
