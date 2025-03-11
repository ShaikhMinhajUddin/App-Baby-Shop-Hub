import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/users/Category_Screen.dart/components/categories_details.dart';
import 'package:flutter/material.dart';

Widget featureButton({
  required BuildContext context, 
  required String title,
  required String icon,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoriesDetails(title: title),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 200,
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 60,
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 10), // Fixed spacing (changed height → width)
          Text(
            title,
            style: const TextStyle(
              fontFamily: semibold,
              color: darkFontGrey,
            ),
          ),
        ],
      ),
    ),
  );
}
