import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/colors.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/users/Cart_Screen/shiping_screen.dart';
import 'package:drawer/services/cart_services.dart';
import 'package:drawer/services/firestore_services.dart';
import 'package:drawer/screens/users/user_widget/beveled_button.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartServices cartservices = CartServices();

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Shopping Cart')),
        body: const Center(child: Text('Please log in to view your cart.')),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: darkFontGrey, fontFamily: semibold),
        ),
      ),
      body: StreamBuilder(
        stream: firestoreService.getCart(currentUser!.uid),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Cart is empty.'));
          }

          var data = snapshot.data!.docs;
          cartservices.calculate(data);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5),
                    itemBuilder: (context, index) {
                      final cartItem = data[index];

                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: cartItem['img'] != null
                              ? Image.memory(
                                  base64Decode(cartItem['img']),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image, size: 50),
                          title: Text(
                            "${cartItem['title']} x[${cartItem['qty']}]",
                            style: const TextStyle(
                              fontFamily: semibold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "Rs: ${cartItem['tprice']}",
                            style: const TextStyle(fontFamily: semibold),
                          ),
                          trailing: IconButton(
                            onPressed: () =>
                                firestoreService.deleteCartDocument(cartItem.id),
                            icon: const Icon(Icons.delete, color: redColor),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(fontFamily: semibold, color: darkFontGrey),
                      ),
                      Text(
                        "Rs: ${cartservices.totalp.value}",
                        style: const TextStyle(fontFamily: semibold, color: redColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 40,
                  child: BeveledButton(
                    title: 'Proceed to Shipping',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShippingScreen()),
                    ),
                    width: MediaQuery.of(context).size.width - 60,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
