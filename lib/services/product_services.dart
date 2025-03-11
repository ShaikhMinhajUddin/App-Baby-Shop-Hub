
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductServices {
  ValueNotifier<int> quantity = ValueNotifier<int>(0);
  ValueNotifier<int> totalprice = ValueNotifier<int>(0);
  ValueNotifier<bool> isFav = ValueNotifier<bool>(false);

  var subcat = [];

  getSubCategories(title) async {
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decode = categoryModelFromJson(data);
    var s =
        decode.categories.where((element) => element.name == title).toList();

    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  increesQuantity(totalquantity) {
    if (quantity.value < totalquantity) {
      quantity.value++;
    }
  }

  decreesQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  calculatetotalprice(price) {
    totalprice.value = price * quantity.value;
  }

  addToCart({title, img, qty, tprice}) async {
    await firestore.collection(cartsCollection).doc().set({
      'title': title,
      'img': img,
      'qty': qty,
      'tprice': tprice,
      'added_by': currentUser!.uid
    }).catchError((e) {
      e.toString();
    });
  }

  addToWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav.value = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Added To Wishlist')));
  }

  removeToWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));

    isFav.value = false;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Remove From Wishlist')));
  }

  checkIfFav(data) async {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav.value = true;
    } else {
      isFav.value = false;
    }
  }
}
