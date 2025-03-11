import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/users/Category_Screen.dart/components/item_details.dart';
import 'package:drawer/services/firestore_services.dart';
import 'package:drawer/services/product_services.dart';
import 'package:drawer/screens/users/user_widget/bg_widget.dart';
import 'package:flutter/material.dart';

class CategoriesDetails extends StatefulWidget {
  final String? title;
  final dynamic data;
  const CategoriesDetails({super.key,this.data, required this.title});

  @override
  _CategoriesDetailsState createState() => _CategoriesDetailsState();
}

class _CategoriesDetailsState extends State<CategoriesDetails> {
  final ProductServices productservices = ProductServices();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSubcategories();
  }

  Future<void> loadSubcategories() async {
    await productservices.getSubCategories(widget.title!);
    setState(() {
      isLoading = false; // Mark loading as complete
    });
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title!,
              style: const TextStyle(fontFamily: bold, color: whiteColor),
            ),
          ),
          body: StreamBuilder(
              stream: firestoreService.getProduct(widget.title),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No Products Found'),
                  );
                } else {
                  var data = snapshot.data!.docs;

                  return isLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Show a loader while loading
                      : Container(
                          padding: const EdgeInsets.all(12),
                          child: 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: List.generate(
                                    productservices.subcat.length,
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      // decoration: BoxDecoration(
                                      //   color: whiteColor,
                                      //   borderRadius: BorderRadius.circular(12),
                                      //   boxShadow: [
                                      //     BoxShadow(
                                      //       color: Colors.grey.withOpacity(0.3),
                                      //       blurRadius: 5,
                                      //       offset: const Offset(0, 3),
                                      //     ),
                                      //   ],
                                      // ),
                                      // child: Center(
                                      //   child: Text(
                                      //     productservices.subcat[index],
                                      //     style: const TextStyle(
                                      //       fontSize: 12,
                                      //       fontFamily: semibold,
                                      //       color: darkFontGrey,
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8,
                                          mainAxisExtent: 300),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        productservices.checkIfFav(data[index]);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ItemDetails(
                                                    title:
                                                        "${data[index]['p_name']}",
                                                    data: data[index])));
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: whiteColor),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.memory(
                                              base64Decode(
                                                  data[index]['p_image']),
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${data[index]['p_name']}",
                                              style: const TextStyle(
                                                fontFamily: semibold,
                                                color: darkFontGrey,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Rs: ${data[index]['p_price']}",
                                              style: const TextStyle(
                                                fontFamily: bold,
                                                color: redColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                }
              })),
    );
  }
}
