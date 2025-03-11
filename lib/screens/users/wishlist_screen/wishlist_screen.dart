import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/services/firestore_services.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(
            color: darkFontGrey,
            fontFamily: semibold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: firestoreService.getWishlist(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Wishlist yet!',
                style: TextStyle(
                  color: darkFontGrey,
                  fontFamily: semibold,
                ),
              ),
            );
          } else {
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.5), // Subtle shadow
                              blurRadius: 4,
                              offset: const Offset(0, 2), // Shadow offset
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Image.memory(
                              base64Decode(data[index]['p_image'])),
                          title: Text(
                            "${data[index]['p_name']} x[${data[index]['p_quantity']}]",
                            style: const TextStyle(
                              fontFamily: semibold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "Rs: ${data[index]['p_price']}",
                            style: const TextStyle(fontFamily: semibold),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await firestore
                                  .collection(productsCollection)
                                  .doc(data[index].id)
                                  .set({
                                    'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
                                  },SetOptions(merge: true));
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: redColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
