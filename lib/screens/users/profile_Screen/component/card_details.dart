import 'package:drawer/consts/colors.dart';
import 'package:drawer/consts/styles.dart';
import 'package:flutter/material.dart';

Widget cartDetails({height,width,String? count, String? title}) {
  return Container(
    width: width,
    height: height,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count!,
          style: const TextStyle(fontFamily: bold, fontSize: 16, color: darkFontGrey),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          title!,
          style: const TextStyle(color: darkFontGrey),
        ),
      ],
    ),
  );
}
