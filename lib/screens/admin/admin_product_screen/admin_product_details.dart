import 'dart:convert';

import 'package:drawer/consts/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:drawer/consts/colors.dart';

class AdminProductDetails extends StatelessWidget {
  final String? title;
  final dynamic data;

  const AdminProductDetails({required this.title, this.data, super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure data is a Map
    final productData = data?.data() as Map<String, dynamic>? ?? {};

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
                    if (productData.containsKey('p_image') &&
                        productData['p_image'] != null)
                      SizedBox(
                        height: 350,
                        child: Swiper(
                          itemCount: productData['p_image'].length,
                          autoplay: false,
                          itemBuilder: (context, index) {
                            return Image.memory(
                              base64Decode(productData['p_image']),
                              width: double.infinity,
                              fit: BoxFit.fill,
                            );
                          },
                        ),
                      )
                    else
                      const Center(child: Text('No images available.')),

                    const SizedBox(height: 20),

                    Text(
                      productData['p_name'] ?? 'No name available.',
                      style: const TextStyle(
                        fontFamily: semibold,
                        fontSize: 16,
                        color: darkFontGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          productData['p_category'] ?? 'No category.',
                          style: const TextStyle(
                            fontFamily: semibold,
                            fontSize: 16,
                            color: darkFontGrey,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          productData.containsKey('p_sub_category')
                              ? productData['p_sub_category']
                              : "No Sub-Category",
                          style: const TextStyle(
                            fontFamily: semibold,
                            fontSize: 16,
                            color: darkFontGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Item Price
                    Text(
                      productData.containsKey('p_price')
                          ? 'Rs: ${productData['p_price']}'
                          : 'Price Not Available',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: bold,
                        color: redColor,
                      ),
                    ),

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
                              const SizedBox(width: 10),
                              Text(
                                productData.containsKey('p_quantity')
                                    ? '${productData['p_quantity']} available'
                                    : 'Quantity Not Available',
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
                      productData.containsKey('p_desc')
                          ? productData['p_desc']
                          : 'No description available.',
                      style: const TextStyle(
                        color: darkFontGrey,
                        fontFamily: semibold,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
