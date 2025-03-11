// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/admin/admin_home.dart';
import 'package:drawer/screens/admin/admin_product_screen/component/product_dropdown.dart';
import 'package:drawer/screens/admin/admin_widget/admin_custom_form.dart';
import 'package:drawer/services/adminproduct_services.dart';
import 'package:drawer/services/validation_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProduct extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;
  const UpdateProduct(
      {super.key, required this.productId, required this.productData});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  var controller = AdminproductServices();
  bool isloading = false;
  Uint8List? profileImageWeb;
  String? profileImagePath;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.getcategory().then((_) {
      setState(() {});

      controller.pnameController.text = widget.productData['p_name'];
      controller.pdescController.text = widget.productData['p_desc'];
      controller.ppriceController.text = widget.productData['p_price'];
      controller.pquantityController.text = widget.productData['p_quantity'];
      controller.categoryvalue = widget.productData['p_category'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteColor),
        title: const Text(
          'Update Product',
          style: TextStyle(fontSize: 16.0, color: whiteColor),
        ),
        actions: [
          isloading
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(color: whiteColor),
                )
              : OutlinedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addData(context);
                    }
                  },
                  child: const Text(
                    'Update Product',
                    style: TextStyle(color: whiteColor),
                  ),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminCustomTextField(
                    label: 'Product Name',
                    hint: 'Enter Product Name',
                    ispass: false,
                    controller: controller.pnameController,
                    validator: validateProductName),
                const SizedBox(height: 10),

                AdminCustomTextField(
                    label: 'Product Description',
                    hint: 'Enter Product Description',
                    ispass: false,
                    controller: controller.pdescController,
                    validator: validateProductDescription),
                const SizedBox(height: 10),

                // Row for Price & Quantity (Better Alignment)
                Row(
                  children: [
                    Expanded(
                      child: AdminCustomTextField(
                          label: 'Product Price',
                          hint: 'Enter Price',
                          ispass: false,
                          controller: controller.ppriceController,
                          validator: validatePrice),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AdminCustomTextField(
                          label: 'Quantity',
                          hint: 'Enter Quantity',
                          ispass: false,
                          controller: controller.pquantityController,
                          validator: validateQuantity),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Category Dropdown
                productDropdown(
                  "Category",
                  controller.categorylist,
                  controller.categoryvalue,
                  (value) {
                    setState(() {
                      controller.categoryvalue = value;
                    });
                  },
                ),
                const SizedBox(height: 10),

                const Text(
                  'Choose Product Image',
                  style: TextStyle(color: whiteColor, fontFamily: bold),
                ),
                const SizedBox(height: 10),

                // Image Picker UI
                Center(
                  child: GestureDetector(
                    onTap: () => changeImage(),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: whiteColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: profileImageWeb != null
                          ? Image.memory(
                              profileImageWeb!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : profileImagePath != null
                              ? Image.file(
                                  File(profileImagePath!),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.memory(
                                  base64Decode(widget.productData['p_image']),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  'First image will be your display image',
                  style: TextStyle(color: fontGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addData(BuildContext context) async {
    try {
      if (controller.categoryvalue == null ||
          controller.categoryvalue.isEmpty) {
        showError("Please select a Category");
        return;
      }

      if ((kIsWeb && profileImageWeb == null) ||
          (!kIsWeb && profileImagePath == null)) {
        showError("Please select an image");
        return;
      }

      setState(() {
        isloading = true;
      });

      String base64image;
      if (kIsWeb) {
        base64image = base64Encode(profileImageWeb!);
      } else {
        base64image = base64Encode(File(profileImagePath!).readAsBytesSync());
      }

      var store =
          firestore.collection(productsCollection).doc(widget.productId);
      await store.update({
        'isFeatured': false,
        'p_category': controller.categoryvalue,
        'p_image': base64image,
        'p_wishlist': FieldValue.arrayUnion([]),
        'p_desc': controller.pdescController.text,
        'p_name': controller.pnameController.text,
        'p_price': controller.ppriceController.text,
        'p_quantity': controller.pquantityController.text,
        'featured_id': ''
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const AdminHome()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Update Product Successfull.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Failed to Add details: $e',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Future<void> changeImage() async {
    setState(() {
      isloading = true;
    });
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) return;

      if (kIsWeb) {
        profileImageWeb = await pickedFile.readAsBytes();
      } else {
        profileImagePath = pickedFile.path;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
    setState(() {
      isloading = false;
    });
  }

  void notifyListeners() {}
}
