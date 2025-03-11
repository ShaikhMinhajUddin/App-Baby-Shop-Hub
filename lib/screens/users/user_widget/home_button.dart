import 'package:drawer/consts/consts.dart';
import 'package:flutter/material.dart';

Widget homeButton({
  required String title,
  required String iconPath,
  required VoidCallback onTap,
  double width = 100 ,// Default width
  double height = 100, // Default height
}) {
  return GestureDetector(
    onTap: onTap, // Handles button taps
    child: Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Shadow color
            blurRadius: 5, // Spread of shadow
            offset: const Offset(0, 3), // Position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.redAccent.withOpacity(0.2), // Icon background
            ),
            child: Image.asset(
              iconPath, // Correct path for the image asset
              width: 30, // Adjusted size for better visuals
              height: 30,
            ),
          ),
          const SizedBox(
            height: 10, // Spacing between icon and text
          ),
          Text(
            title, // Displays the provided title
            style: const TextStyle(
              fontFamily: semibold,
              fontSize: 14,
              color: darkFontGrey,
              letterSpacing: 0.5, // Slight letter spacing
            ),
            textAlign: TextAlign.center, // Centers text horizontally
          ),
        ],
      ),
    ),
  );
}
