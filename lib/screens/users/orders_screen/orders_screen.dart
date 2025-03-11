import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/users/orders_screen/order_details.dart';
import 'package:drawer/services/firestore_services.dart';
import 'package:flutter/material.dart';

class OrdersScreem extends StatelessWidget {
  const OrdersScreem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: darkFontGrey,
            fontFamily: semibold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: firestoreService.getAllOrders(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No orders yet!',
                style: TextStyle(
                  color: darkFontGrey,
                  fontFamily: semibold,
                ),
              ),
            );
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, int index) {
                return ListTile(
                  leading: Text(
                    "${index + 1}",
                    style: const TextStyle(
                        color: darkFontGrey, fontSize: 13, fontFamily: bold),
                  ),
                  title: Text(
                    data[index]['order_code'].toString(),
                    style:
                        const TextStyle(color: redColor, fontFamily: semibold),
                  ),
                  subtitle: Text(
                    "Rs: ${data[index]['total_amount'].toString()}",
                    style: const TextStyle(fontFamily: bold),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context)=> OrderDetails(data: data[index])));
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: darkFontGrey,
                      )),
                );
              },
            );
          }
        },
      ),
    );
  }
}
