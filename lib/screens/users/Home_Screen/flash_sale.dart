import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/users/Category_Screen.dart/components/item_details.dart';
import 'package:drawer/services/firestore_services.dart';
import 'package:flutter/material.dart';

class FlashSale extends StatelessWidget {
  const FlashSale({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flash Sale",
            style: TextStyle(color: fontGrey, fontFamily: bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DealBox at the top
              DealBox(),

              // FutureBuilder for fetching products
              FutureBuilder<QuerySnapshot>(
                future: firestoreService.getflashsaleProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No products available"));
                  }

                  var allProducts = snapshot.data!.docs;

                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: allProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 300,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigate to product details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemDetails(
                                title: "${allProducts[index]['p_name']}",
                                data: allProducts[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.memory(
                                base64Decode(allProducts[index]['p_image']),
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                fit: BoxFit.fill,
                              ),
                              const Spacer(),
                              Text("${allProducts[index]['p_name']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87)),
                              const SizedBox(height: 5),
                              Text("Rs: ${allProducts[index]['p_price']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DealBox extends StatefulWidget {
  @override
  _DealBoxState createState() => _DealBoxState();
}

class _DealBoxState extends State<DealBox> {
  String _dealText = "Flash sale Deal";
  final List<String> _deals = [
    "Get Big Discounts!",
    "30% off in each product",
    "Delivery free for only today"
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _changeDealText,
      child: AnimatedSwitcher(
        duration: Duration(seconds: 1),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: Container(
          key: ValueKey<String>(_dealText),
          padding: EdgeInsets.all(20),
          color: Colors.red,
          height: 100, // Added height to make space for scrolling
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 1.0, end: 0.0),
              duration: Duration(seconds: 3),
              builder: (BuildContext context, double value, Widget? child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    _dealText,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              onEnd: () {
                // Change text when animation ends
                setState(() {
                  _dealText = (_deals..shuffle()).first; // Randomize text
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  void _changeDealText() {
    setState(() {
      _dealText = (_deals..shuffle()).first; // Randomize text
    });
  }
}
