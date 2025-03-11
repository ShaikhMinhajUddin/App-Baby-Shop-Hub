import 'package:drawer/consts/consts.dart';
import 'package:flutter/material.dart';

Widget bgWidget({Widget? child, double? height}) {
  return Container(
    height: height,
    decoration: const BoxDecoration(
      image: DecorationImage(
      image: AssetImage(imgBackground,),
      fit: BoxFit.fill,),
    ),
    child: child,
  );
}
