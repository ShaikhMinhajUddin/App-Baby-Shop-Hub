import 'dart:convert';

import 'package:drawer/consts/consts.dart';
import 'package:drawer/consts/styles.dart';
import 'package:drawer/screens/users/login_register/feedbackform.dart';
import 'package:drawer/screens/users/login_register/loginpage.dart';
import 'package:drawer/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:drawer/consts/colors.dart';
import 'package:drawer/screens/users/user_widget/beveled_button.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;

  const ItemDetails({required this.title, this.data, super.key});

  @override
  Widget build(BuildContext context) {
    var productservices = ProductServices();
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: Text(
          title ?? 'Item Details',
          style: const TextStyle(
            fontFamily: bold,
            color: darkFontGrey,
          ),
        ),
        actions: [
          // Feedback Button (Red button before wishlist)
          TextButton(
            onPressed: () async {
              if (currentUser == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please login first to give feedback.')),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackFormPage()),
                );
              }
            },
            child: const Text('Feedback', style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(backgroundColor: Colors.red),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: productservices.isFav,
            builder: (context, isFavorite, child) {
              return IconButton(
                onPressed: () {
                  if (currentUser != null) {
                    if (isFavorite) {
                      productservices.removeToWishlist(data.id, context);
                    } else {
                      productservices.addToWishlist(data.id, context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Please Login first then add to Wishlist..')));
                  }
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isFavorite ? redColor : darkFontGrey,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Swiper for Images
                    if (data != null && data['p_image'] != null)
                      SizedBox(
                        height: 350,
                        child: Swiper(
                          itemCount: data['p_image'].length,
                          autoplay: false,
                          itemBuilder: (context, index) {
                            return Image.memory(
                              base64Decode(data['p_image']),
                              width: double.infinity,
                              fit: BoxFit.fill,
                            );
                          },
                        ),
                      )
                    else
                      const Center(child: Text('No images available.')),

                    const SizedBox(height: 20),
                    // Item Description
                    Text(
                      data['p_name'] ?? 'Item Description Unavailable.',
                      style: const TextStyle(
                        fontFamily: semibold,
                        fontSize: 16,
                        color: darkFontGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Item Price
                    Text(
                      data['p_price'] != null
                          ? 'Rs: ${data['p_price']}'
                          : 'Price Not Available',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: bold,
                        color: redColor,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              "Quantity",
                              style: TextStyle(color: textfieldGrey),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    productservices.decreesQuantity();
                                    productservices.calculatetotalprice(
                                        int.parse(data['p_price']));
                                  },
                                  icon: const Icon(Icons.remove)),
                              ValueListenableBuilder<int>(
                                valueListenable: productservices
                                    .quantity, // Track changes to quantity
                                builder: (context, quantityValue, child) {
                                  return Text(
                                    quantityValue.toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: darkFontGrey,
                                        fontFamily: bold),
                                  );
                                },
                              ),
                              IconButton(
                                  onPressed: () {
                                    productservices.increesQuantity(
                                        int.parse(data['p_quantity']));
                                    productservices.calculatetotalprice(
                                        int.parse(data['p_price']));
                                  },
                                  icon: const Icon(Icons.add)),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${data['p_quantity']} available',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: darkFontGrey,
                                    fontFamily: bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              "Total: ",
                              style: TextStyle(color: textfieldGrey),
                            ),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: productservices
                                .totalprice, // Listen to totalprice changes
                            builder: (context, totalPriceValue, child) {
                              return Text(
                                'Rs: $totalPriceValue', // Display the updated total price
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: redColor,
                                  fontFamily: bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Description Section
                    const Text(
                      'Description',
                      style: TextStyle(
                        color: darkFontGrey,
                        fontFamily: semibold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      data['p_desc'] ?? 'This is a dummy description....',
                      style: const TextStyle(
                        color: darkFontGrey,
                        fontFamily: semibold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Video List
                  ],
                ),
              ),
            ),
          ),
          // Add to Cart Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: BeveledButton(
              width: MediaQuery.of(context).size.width,
              title: 'Add To Cart',
              onTap: () {
                if (currentUser == null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please Login first then add to cart..'),
                  ));
                } else {
                  if (productservices.quantity.value > 0) {
                    productservices.addToCart(
                        img: data['p_image'],
                        title: data['p_name'],
                        qty: productservices.quantity.value,
                        tprice: productservices.totalprice.value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Item added to cart")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Minimum 1 product is required")));
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
