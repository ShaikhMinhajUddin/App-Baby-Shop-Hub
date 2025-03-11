import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:drawer/consts/firebase_consts.dart';

class CartServices {
  ValueNotifier<int> totalp = ValueNotifier<int>(0);
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final phoneController = TextEditingController();
  var product = [];
  late QuerySnapshot productSnapshot;

  final ValueNotifier<int> paymentIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> isloading = ValueNotifier<bool>(false);

  void changePaymentIndex(int index) {
    paymentIndex.value = index; // Update selected payment index
  }

  var username = '';

  getUserName() async {
    var n = await firestore
        .collection(userCollection)
        .where('id', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['name'];
      }
    });
    return n;
  }

  /// **Calculate Total Price from Cart Data**
  void calculate(List<QueryDocumentSnapshot> data) {
    totalp.value = 0;
    for (var doc in data) {
      int price = int.tryParse(doc['tprice'].toString()) ?? 0;
      totalp.value += price;
      print('Adding price: $price, Current Total: ${totalp.value}');
    }
  }

  /// **Place Order**
  Future<void> placeOrder({
    required String orderPaymentMethod,
  }) async {
    isloading.value = true;

    // Fetch product details
    await getProductDetails();
    calculate(productSnapshot.docs); // Ensure total price is updated
    print("Final Total Amount Before Placing Order: ${totalp.value}");

    await firestore.collection(ordersCollection).doc().set({
      'order_code': '38929834',
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser?.uid,
      'order_name': username,
      'order_by_email': currentUser?.email,
      'order_by_address': addressController.text,
      'order_by_city': cityController.text,
      'order_by_state': stateController.text,
      'order_by_phone': phoneController.text,
      'payment_method': orderPaymentMethod,
      'shipping_method': 'Home Delivery',
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalp.value, // Updated total price
      'order': FieldValue.arrayUnion(product),
    });

    isloading.value = false;
  }

  /// **Fetch Product Details from Firestore**
  Future<void> getProductDetails() async {
    product.clear();
    productSnapshot = await firestore.collection(cartsCollection).get();

    for (var doc in productSnapshot.docs) {
      product.add({
        'qty': doc['qty'],
        'title': doc['title'],
        'tprice': doc['tprice'],
      });
    }
    print("Products in Cart: $product");
  }

  /// **Clear Cart After Order**
  Future<void> clearCart() async {
    for (var doc in productSnapshot.docs) {
      await firestore.collection(cartsCollection).doc(doc.id).delete();
    }
  }
}
