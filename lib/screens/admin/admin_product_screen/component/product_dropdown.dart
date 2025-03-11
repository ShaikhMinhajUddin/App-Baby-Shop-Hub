import 'package:drawer/consts/colors.dart';
import 'package:flutter/material.dart';

Widget productDropdown(
    String hint, List<String> list, String? dropvalue, Function(String) onChanged) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        hint: Text(
          hint,
          style: TextStyle(color: darkFontGrey),
        ),
        value: (dropvalue != null && list.contains(dropvalue)) ? dropvalue : null, 
        items: list.map((e) {
          return DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
        isExpanded: true,
      ),
    ),
  );
}
