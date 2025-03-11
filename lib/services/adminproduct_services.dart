// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminproductServices {
  // Controllers for input fields
  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();

  // Categories and subcategories
  List<String> categorylist = [];
  List<Category> category = [];
  List<String> pimageslinks = [];

  // ignore: unnecessary_question_mark
  List<dynamic?> pimagelist = List.filled(3, null, growable: false);

  String categoryvalue = '';
Future<void> getcategory() async {
  try {
    String data = await rootBundle.loadString("lib/services/category_model.json");
    print("Raw JSON Data: $data"); // Debugging step

    var cat = categoryModelFromJson(data);
    print("Parsed Data: $cat"); // Debugging step

    if (cat != null && cat.categories != null) {
      print("Categories Loaded: ${cat.categories.map((c) => c.name).toList()}");

      // Extract only category names
      categorylist = cat.categories.map((c) => c.name).toList();
    } else {
      print("No categories found!");
    }
  } catch (e) {
    debugPrint("Error loading categories: $e");
  }
}



  void populateCategoryList() {
  if (categorylist == null) {
    categorylist = [];
  }
  categorylist.clear();

  if (category != null && category.isNotEmpty) {
    for (var item in category) {
      categorylist.add(item.name);
    }
  }

  print("Dropdown Categories: $categorylist"); // Debugging
}

  addFeatured(docID) async {
    await firestore.collection(productsCollection).doc(docID).set(
        {'featured_id': currentUser!.uid, 'isFeatured': true},
        SetOptions(merge: true));
  }

  removeFeatured(docID) async {
    await firestore
        .collection(productsCollection)
        .doc(docID)
        .set({'featured_id': '', 'isFeatured': false}, SetOptions(merge: true));
  }

  removeProduct(docID) async {
    await firestore.collection(productsCollection).doc(docID).delete();
  }

  removeOrders(docID) async {
    await firestore.collection(ordersCollection).doc(docID).delete();
  }

  addtopCategory(docID) async {
    await firestore
        .collection(productsCollection)
        .doc(docID)
        .set({'TopCategory': true}, SetOptions(merge: true));
  }

  removetopCategory(docID) async {
    await firestore
        .collection(productsCollection)
        .doc(docID)
        .set({'TopCategory': false}, SetOptions(merge: true));
  }

  addtodaydeals(docID) async {
    await firestore
        .collection(productsCollection)
        .doc(docID)
        .set({'TodayDeals': true}, SetOptions(merge: true));
  }

  removetodaydeals(docID) async {
    await firestore
        .collection(productsCollection)
        .doc(docID)
        .set({'TodayDeals': false}, SetOptions(merge: true));
  }

  addflashsale(docID) async {
    await firestore
        .collection(productsCollection)
        .doc(docID)
        .set({'FlashSale': true}, SetOptions(merge: true));
  }

  removeflashsale(docID) async {
    await firestore
        .collection(productsCollection)
        .doc(docID)
        .set({'FlashSale': false}, SetOptions(merge: true));
  }
}
