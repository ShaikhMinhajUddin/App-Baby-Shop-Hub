import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/colors.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/users/user_widget/beveled_button.dart';
import 'package:drawer/screens/users/user_widget/order_placed_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminOrderDetails extends StatefulWidget {
  final dynamic data;
  const AdminOrderDetails({super.key, this.data});

  @override
  State<AdminOrderDetails> createState() => _AdminOrderDetailsState();
}

class _AdminOrderDetailsState extends State<AdminOrderDetails> {
  bool confirmed = false;
  bool ondelivery = false;
  bool delivered = false;

  // Send email to the user
  Future<void> sendEmail(String subject, String body, String recipientEmail) async {
    const emailApiUrl = 'https://your-api-endpoint.com/sendEmail'; // Replace with your email API endpoint
    final response = await http.post(
      Uri.parse(emailApiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'subject': subject,
        'body': body,
        'recipient': recipientEmail,
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully.');
    } else {
      print('Failed to send email.');
    }
  }

  // Change the order status and send email
  onchangeStatus({title, status, docID}) async {
    var store = FirebaseFirestore.instance.collection(ordersCollection).doc(docID);
    await store.set({title: status}, SetOptions(merge: true));

    // Send email based on the status change
    if (title == "order_confirmed" && status == true) {
      sendEmail(
        'Your Order is Confirmed',
        'Hello, your order has been confirmed and is being processed.',
        widget.data['order_by_email'],
      );
    } else if (title == "order_on_delivery" && status == true) {
      sendEmail(
        'Your Order is Out for Delivery',
        'Hello, your order is now out for delivery.',
        widget.data['order_by_email'],
      );
    } else if (title == "order_delivered" && status == true) {
      sendEmail(
        'Your Order Has Been Delivered',
        'Hello, your order has been successfully delivered.',
        widget.data['order_by_email'],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    confirmed = widget.data['order_confirmed'];
    ondelivery = widget.data['order_on_delivery'];
    delivered = widget.data['order_delivered'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders Details',
          style: TextStyle(fontSize: 16.0, color: darkFontGrey),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !confirmed,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: BeveledButton(
              title: 'Confirm Order',
              onTap: () {
                setState(() {
                  confirmed = true;
                });
                onchangeStatus(
                    title: "order_confirmed",
                    docID: widget.data.id,
                    status: true);
              },
              width: MediaQuery.of(context).size.width),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildOrderStatusContainer(),
              const SizedBox(height: 10),
              buildOrderDetailsContainer(),
              const Divider(),
              const SizedBox(height: 10),
              buildOrderedProductsList(),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderStatusContainer() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Visibility(
        visible: confirmed,
        child: Column(
          children: [
            buildSwitchTile('Placed', true, (value) {}),
            buildSwitchTile('Confirmed', confirmed, (value) {
              setState(() => confirmed = value);
            }),
            buildSwitchTile('On Delivery', ondelivery, (value) {
              setState(() => ondelivery = value);
              onchangeStatus(
                  title: "order_on_delivery",
                  docID: widget.data.id,
                  status: value);
            }),
            buildSwitchTile('Delivered', delivered, (value) {
              setState(() => delivered = value);
              onchangeStatus(
                  title: "order_delivered",
                  docID: widget.data.id,
                  status: value);
            }),
          ],
        ),
      ),
    );
  }

  Widget buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      activeColor: golden,
      value: value,
      onChanged: onChanged,
      title: Text(title,
          style: const TextStyle(fontFamily: bold, color: darkFontGrey)),
    );
  }

  Widget buildOrderDetailsContainer() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          orderPlaceDetails(
              title1: 'Order Code',
              d1: widget.data['order_code'],
              title2: 'Shipping Method',
              d2: widget.data['shipping_method']),
          orderPlaceDetails(
              title1: 'Order Date',
              d1: intl.DateFormat()
                  .add_yMd()
                  .format((widget.data['order_date'].toDate()))),
          orderPlaceDetails(
              title1: 'Payment Status',
              d1: 'Unpaid',
              title2: 'Delivery Status',
              d2: 'Order Placed'),
          buildShippingDetails(),
        ],
      ),
    );
  }

  Widget buildShippingDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to top
        children: [
          // Left Side: Shipping Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shipping Address',
                  style: TextStyle(fontFamily: semibold),
                ),
                const SizedBox(height: 4),
                ...[ 
                  'order_name',
                  'order_by_email',
                  'order_by_address',
                  'order_by_city',
                  'order_by_phone'
                ].map((field) => Text(
                      '${widget.data[field]}',
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis), // Handle long text
                      maxLines: 2, // Limit to 2 lines
                    )),
              ],
            ),
          ),

          // Right Side: Total Amount
          SizedBox(
            width: 120, // Fixed width for total amount section
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(fontFamily: semibold),
                ),
                Text(
                  'Rs: ${widget.data['total_amount']}',
                  style: const TextStyle(color: redColor, fontFamily: bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderedProductsList() {
    return Column(
      children: [
        const Center(
          child: Text('Ordered Product',
              style: TextStyle(
                  fontFamily: semibold, fontSize: 16, color: darkFontGrey)),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.data['order']?.length ?? 0,
            itemBuilder: (context, index) {
              final orderItem = widget.data['order'][index];
              return orderPlaceDetails(
                title1: orderItem['title'] ?? 'N/A',
                d1: "${orderItem['qty'] ?? 0}x",
                title2: 'Price',
                d2: "Rs: ${orderItem['tprice']}",
              );
            },
          ),
        ),
      ],
    );
  }
}
