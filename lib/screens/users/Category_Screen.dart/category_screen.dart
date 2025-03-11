import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/users/Category_Screen.dart/components/categories_details.dart';
import 'package:drawer/services/product_services.dart';
import 'package:drawer/screens/users/user_widget/bg_widget.dart';
import 'package:drawer/screens/users/user_widget/lish.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var productservices = ProductServices();

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Categories',
            style: TextStyle(fontFamily: bold, color: Colors.black),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20),
            shrinkWrap: false,
            itemCount: categoriesList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 180,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  productservices.getSubCategories(categoriesList[index]);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoriesDetails(
                                title: categoriesList[index],
                                
                              )));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: whiteColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        categorylisticon[index],
                        width: 120,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                      const Spacer(),
                      Center(
                        child: Text(
                          categoriesList[index],
                          style: const TextStyle(
                            fontFamily: semibold,
                            color: darkFontGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
