import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/screens/admin/admin_orders_screen/admin_order_details.dart';
import 'package:drawer/services/adminproduct_services.dart';
import 'package:drawer/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:drawer/consts/colors.dart';
import 'package:drawer/consts/styles.dart';
import 'package:intl/intl.dart' as intl;

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = AdminproductServices();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Orders',
          style: TextStyle(fontFamily: bold, fontSize: 16, color: darkFontGrey),
        ),
        actions: [
          Text(intl.DateFormat('EEE, MMM d,' 'yy ').format(DateTime.now()))
        ],
      ),
      body: StreamBuilder(
          stream: firestoreService.getAllOrder(),
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(
                        data.length,
                        (index) => Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminOrderDetails(
                                                  data: data[index])));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                tileColor: lightGrey,
                                title: Text(
                                  data[index]['order_code'].toString(),
                                  style: TextStyle(
                                      color: Colors.deepPurple[900],
                                      fontFamily: bold),
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          color: fontGrey,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          intl.DateFormat('EEE, MMM d,' 'yy ')
                                              .format((data[index]['order_date']
                                                  .toDate())),
                                          style: const TextStyle(
                                              fontFamily: bold,
                                              color: fontGrey),
                                        )
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        const Icon(
                                          Icons.payment,
                                          color: fontGrey,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          'Unpaid',
                                          style: TextStyle(
                                              color: redColor,
                                              fontFamily: bold),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        controller.removeOrders(data[index].id);
                                      },
                                      child: const Text('Cancel Order'),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Rs: ${data[index]['total_amount']}',
                                      style: TextStyle(
                                        color: Colors.deepPurple[900],
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                  ),
                ),
              );
            }
          }),
    );
  }
}
