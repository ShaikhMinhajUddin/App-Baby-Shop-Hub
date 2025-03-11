// ignore_for_file: unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/consts.dart';

class firestoreService {
  //get user details

  static getUser(uid) {
    return firestore
        .collection(userCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  static getAllUser() {
    return firestore.collection(userCollection).snapshots();
  }

  static getProduct(category) {
    return firestore
        .collection(productsCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }

  static getCart(uid) {
    return firestore
        .collection(cartsCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  static deleteCartDocument(docId) {
    return firestore.collection(cartsCollection).doc(docId).delete();
  }

  static getAllOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getAllOrder() {
    return firestore.collection(ordersCollection).snapshots();
  }

  static getWishlist() {
    return firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getCount() async {
    var res = await Future.wait([
      firestore
          .collection(cartsCollection)
          .where('added_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(productsCollection)
          .where('p_wishlist', arrayContains: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(ordersCollection)
          .where('order_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
    ]);
    return res;
  }

static Future<List<int>> getAdminCount() async {
  var firestore = FirebaseFirestore.instance;

  var res = await Future.wait([
    // Orders Count
    firestore.collection(ordersCollection).get().then((value) => value.docs.length),

    firestore.collection(productsCollection).get().then((value) {
      int totalWishlistCount = 0;
      for (var doc in value.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('p_wishlist') && data['p_wishlist'] is List) {
          totalWishlistCount += (data['p_wishlist'] as List).length;
        }
      }
      return totalWishlistCount;
    }),

    // Products Count
    firestore.collection(productsCollection).get().then((value) => value.docs.length),

    // Total Sales Calculation (Summing totalAmount from all orders)
    firestore.collection(ordersCollection).get().then((value) {
      int totalSales = 0;
      for (var doc in value.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('total_amount') && data['total_amount'] is num) {
          totalSales += (data['total_amount'] as num).toInt();
        }
      }
      return totalSales;
    }),
  ]);

  return res.map((e) => e as int).toList(); // Ensure all results are int
}

  static Stream<QuerySnapshot> getAllProducts() {
    return FirebaseFirestore.instance
        .collection(productsCollection)
        .snapshots();
  }

  static getFeaturedProducts() {
    return firestore
        .collection(productsCollection)
        .where('isFeatured', isEqualTo: true)
        .get();
  }

  static gettodaydealsProducts() {
    return firestore
        .collection(productsCollection)
        .where('TodayDeals', isEqualTo: true)
        .get();
  }

  static getflashsaleProducts() {
    return firestore
        .collection(productsCollection)
        .where('FlashSale', isEqualTo: true)
        .get();
  }

  static searchProducts(title) {
    return firestore.collection(productsCollection).get();
  }

  static getSellerRatingsAndReviews() {}
}
