import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/colors.dart';
import 'package:drawer/screens/users/Category_Screen.dart/components/item_details.dart';
import 'package:drawer/services/firestore_services.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final String? title;
  const SearchScreen({super.key, this.title});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title!,
          style: const TextStyle(color: darkFontGrey),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: firestoreService.searchProducts(widget.title),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No products available"));
            }
        
            var data = snapshot.data!.docs;
            var filtered = data
                .where((element) => element['p_name']
                    .toString()
                    .toLowerCase()
                    .contains(widget.title!.toLowerCase()),)
                .toList();
        
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                title: "${filtered[index]['p_name']}",
                                data: filtered[index],
                              )),
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
                        Image.memory(base64Decode(filtered[index]['p_image']),
                            width: MediaQuery.of(context).size.width, height: 200, fit: BoxFit.fill),
                        const Spacer(),
                        Text("${filtered[index]['p_name']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                        const SizedBox(height: 5),
                        Text("Rs: ${filtered[index]['p_price']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
