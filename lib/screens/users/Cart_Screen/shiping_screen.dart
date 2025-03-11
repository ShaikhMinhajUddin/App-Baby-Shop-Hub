import 'package:drawer/consts/firebase_consts.dart';
import 'package:drawer/screens/users/login_register/loginpage.dart';
import 'package:drawer/screens/users/user_widget/lish.dart';
import 'package:drawer/services/validation_services.dart';
import 'package:flutter/material.dart';
import 'package:drawer/consts/colors.dart';
import 'package:drawer/consts/styles.dart';
import 'package:drawer/screens/users/Home_Screen/home.dart';
import 'package:drawer/services/cart_services.dart';
import 'package:drawer/services/product_services.dart';
import 'package:drawer/screens/users/user_widget/beveled_button.dart';
import 'package:drawer/screens/users/user_widget/custom_form.dart';

class ShippingScreen extends StatelessWidget {
  ShippingScreen({super.key});

  final cartServices = CartServices();
  final productServices = ProductServices();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Checkout",
          style: TextStyle(
            color: darkFontGrey,
            fontFamily: semibold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shipping Info Section
              Card(
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Shipping Information",
                          style: TextStyle(
                            fontFamily: bold,
                            fontSize: 18,
                            color: darkFontGrey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hint: 'Enter your address',
                          label: 'Address',
                          controller: cartServices.addressController,
                          ispass: false,
                          validator: validateAddress
                        ),
                        CustomTextField(
                          hint: 'Enter your city',
                          label: 'City',
                          controller: cartServices.cityController,
                          ispass: false,
                          validator: (value) => validateField(value, "City")
                        ),
                        CustomTextField(
                          hint: 'Enter your state',
                          label: 'State',
                          controller: cartServices.stateController,
                          ispass: false,
                          validator: (value) => validateField(value, "State")
                        ),
                        CustomTextField(
                          hint: 'Enter your phone',
                          label: 'Phone',
                          controller: cartServices.phoneController,
                          ispass: false,
                          validator: validatePhoneNumber
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Payment Method Section
              Card(
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ValueListenableBuilder<int>(
                    valueListenable: cartServices.paymentIndex,
                    builder: (context, selectedIndex, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Payment Method",
                            style: TextStyle(
                              fontFamily: bold,
                              fontSize: 18,
                              color: darkFontGrey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: paymentMethoodList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () =>
                                    cartServices.changePaymentIndex(index),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: selectedIndex == index
                                          ? redColor
                                          : Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          paymentMethoodList[index],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          paymentMethood[index],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: semibold,
                                            color: selectedIndex == index
                                                ? redColor
                                                : darkFontGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Order Summary Button
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ValueListenableBuilder<bool>(
                  valueListenable:
                      cartServices.isloading, // Listens to loading state
                  builder: (context, isLoading, _) {
                    return isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : BeveledButton(
                            title: 'Place The Order',
                            onTap: () async {
                              if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                              if (currentUser == null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Please Login first then add to place order..'),
                                ));
                              } else {
                                // Check if address is filled
                                if (cartServices
                                    .addressController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please fill in your shipping details.'),
                                    ),
                                  );
                                  return;
                                }

                                // Start loading
                                cartServices.isloading.value = true;

                                try {
                                  // Ensure total price is calculated before order
                                  await cartServices.getProductDetails();
                                  cartServices.calculate(
                                      cartServices.productSnapshot.docs);

                                  print(
                                      "Total Price Before Order: ${cartServices.totalp.value}");

                                  // Place order logic
                                  await cartServices.placeOrder(
                                    orderPaymentMethod: paymentMethood[
                                        cartServices.paymentIndex.value],
                                  );

                                  // Clear cart and navigate to home
                                  await cartServices.clearCart();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Your Order Placed Successfully.'),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Home(),
                                    ),
                                  );
                                } catch (e) {
                                  // Handle errors
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                    ),
                                  );
                                } finally {
                                  // Stop loading
                                  cartServices.isloading.value = false;
                                }
                              }
                            },
                            width: MediaQuery.of(context).size.width - 40,
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
