import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/screens/users/Category_Screen.dart/components/item_details.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class AllProductsPage extends StatelessWidget {
  final Stream<QuerySnapshot> productStream;

  const AllProductsPage({Key? key, required this.productStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Products")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<QuerySnapshot>(
          stream: productStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No products available"));
            }

            var displayedProducts = snapshot.data!.docs;

            return GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: displayedProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 300,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetails(
                          title: displayedProducts[index]['p_name'],
                          data: displayedProducts[index],
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
                        Expanded(
                          child: Image.memory(
                            base64Decode(displayedProducts[index]['p_image']),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          displayedProducts[index]['p_name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      
                        Text(
                          "Rs: ${displayedProducts[index]['p_price']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                         const SizedBox(height: 5),
                       
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
