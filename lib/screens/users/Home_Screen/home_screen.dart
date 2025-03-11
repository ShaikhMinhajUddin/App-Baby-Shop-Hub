import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/screens/users/Category_Screen.dart/components/item_details.dart';
import 'package:drawer/screens/users/Home_Screen/component/all_product.dart';
import 'package:drawer/screens/users/Home_Screen/component/feature_button.dart';
import 'package:drawer/screens/users/Home_Screen/component/seach_screen.dart';
import 'package:drawer/screens/users/Home_Screen/flash_sale.dart';
import 'package:drawer/screens/users/Home_Screen/today_deals.dart';
import 'package:drawer/services/firestore_services.dart';
import 'package:drawer/screens/users/user_widget/home_button.dart';
import 'package:drawer/screens/users/user_widget/lish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:drawer/consts/consts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var searchController = TextEditingController();
  // Static list of seller reviews
  final List<Map<String, String>> sellerReviews = [
    {
      'image': 'assets/images/s1.jpg',
      'name': 'John Doe',
      'rating': '4.5',
      'reviews': 'Great seller! Fast shipping and excellent quality.',
    },
    {
      'image': 'assets/images/s2.jpg',
      'name': 'Jane Smith',
      'rating': '4.0',
      'reviews': 'Good quality, but shipping took longer than expected.',
    },
    {
      'image': 'assets/images/s3.webp',
      'name': 'Alice Johnson',
      'rating': '5.0',
      'reviews': 'Amazing experience, will definitely buy again!',
    },
    {
      'image': 'assets/images/s4.webp',
      'name': 'Mark Lee',
      'rating': '3.5',
      'reviews': 'Item was as described, but customer service could be better.',
    },
    {
      'image': 'assets/images/s5.jpg',
      'name': 'Chris Martin',
      'rating': '4.8',
      'reviews': 'Excellent service, fast shipping, and great communication.',
    },
    {
      'image': 'assets/images/s6.jpg',
      'name': 'Sophie Turner',
      'rating': '4.2',
      'reviews': 'Good product, but packaging could use some improvement.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(12),
        color: lightGrey,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Column(
            children: [
              // Search bar with logo and support button in one row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Align vertically
                children: [
                  // BabyShop Hub Logo
                  GestureDetector(
                    onTap: () {
                      // Add functionality for logo tap (e.g., navigate to home page)
                    },
                    child: Image.asset(
                      'assets/images/babyshop_hub_logo.png', // Replace with the correct logo path
                      width: 180, // Increased width (adjust as needed)
                      height: 100, // Increased height (adjust as needed)
                    ),
                  ),

                  const SizedBox(
                      width: 10), // Minor space between logo and search bar

                  // Search bar
                  Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: MediaQuery.of(context).size.width *
                        0.55, // Adjust width to fill space
                    color: lightGrey,
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (searchController.text.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchScreen(
                                    title: searchController.text,
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.search),
                        ),
                        filled: true,
                        fillColor: whiteColor,
                        hintText: 'Search anything...',
                        hintStyle: const TextStyle(color: textfieldGrey),
                      ),
                    ),
                  ),

                  const SizedBox(
                      width:
                          10), // Minor space between search bar and support button
                ],
              ),
              const SizedBox(height: 5),

              // Swiper Slider
              Container(
                height: 200,
                child: Swiper(
                  itemCount: brandlist.length,
                  autoplay: true,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Image.asset(
                        brandlist[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Today Deals and Flash Sale Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: homeButton(
                      width: 150,
                      height: 140,
                      iconPath: index == 0 ? icTodaysDeal : icFlashDeal,
                      title: index == 0 ? 'Today Deal' : 'Flash Sale',
                      onTap: () {
                        index == 0
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TodayDeals(),
                                ),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlashSale(),
                                ),
                              );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Featured Categories
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Featured Category',
                  style: TextStyle(
                    color: darkFontGrey,
                    fontSize: 18,
                    fontFamily: semibold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    categoriesList123.length,
                    (index) => Column(
                      children: [
                        featureButton(
                          context: context,
                          icon: categorylisticon12[index],
                          title: categoriesList12[index],
                        ),
                        const SizedBox(height: 10),
                        featureButton(
                          context: context,
                          icon: categorylisticon123[index],
                          title: categoriesList123[index],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Featured Products Section
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: const BoxDecoration(color: redColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Featured Products',
                      style: TextStyle(
                        color: whiteColor,
                        fontFamily: bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FutureBuilder(
                        future: firestoreService.getFeaturedProducts(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text('No Featured Products yet!'));
                          } else {
                            var featureData = snapshot.data!.docs;
                            return Row(
                              children: List.generate(
                                featureData.length,
                                (index) => Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ItemDetails(
                                            title:
                                                "${featureData[index]['p_name']}",
                                            data: featureData[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.memory(
                                          base64Decode(
                                              featureData[index]['p_image']),
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "${featureData[index]['p_name']}",
                                          style: const TextStyle(
                                            fontFamily: semibold,
                                            color: darkFontGrey,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Rs: ${featureData[index]['p_price']}",
                                          style: const TextStyle(
                                            fontFamily: bold,
                                            color: redColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // All Products Section
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'All Products',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream: firestoreService.getAllProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text("No products available"));
                        }

                        var allProducts = snapshot.data!.docs;
                        var displayedProducts = allProducts
                            .take(8)
                            .toList(); // Show only 8 products

                        return Column(
                          children: [
                            GridView.builder(
                              padding: const EdgeInsets.all(8),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: displayedProducts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 300,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItemDetails(
                                          title:
                                              "${displayedProducts[index]['p_name']}",
                                          data: displayedProducts[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.memory(
                                          base64Decode(displayedProducts[index]
                                              ['p_image']),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 200,
                                          fit: BoxFit.fill,
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${displayedProducts[index]['p_name']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Rs: ${displayedProducts[index]['p_price']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (allProducts.length > 8)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AllProductsPage(
                                          productStream:
                                              firestoreService.getAllProducts(),
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange[900],
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                  child: const Text(
                                    "View All",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Seller Ratings and Reviews Section
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Seller Ratings & Reviews',
                  style: TextStyle(
                      color: darkFontGrey, fontSize: 18, fontFamily: semibold),
                ),
              ),
              const SizedBox(height: 20),

              // Horizontal Scroll of Seller Reviews
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(sellerReviews.length, (index) {
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display user image
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage(sellerReviews[index]['image']!),
                          ),
                          const SizedBox(height: 10),
                          // Display seller name
                          Text(
                            sellerReviews[index]['name']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          // Display rating and reviews count
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amberAccent),
                              Text(
                                '${sellerReviews[index]['rating']} (10 Reviews)',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Display review text
                          Text(
                            sellerReviews[index]['reviews']!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
