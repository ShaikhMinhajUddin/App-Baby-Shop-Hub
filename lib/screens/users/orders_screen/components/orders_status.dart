import 'package:drawer/consts/consts.dart';
import 'package:flutter/material.dart';

Widget ordersStatus({icons, color, title, showDone}) {
  return ListTile(
    leading: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4)
      ),
      child: Icon(
        icons,
        color: color,
      ),
    ),
    trailing: SizedBox(
      height: 100,
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
            style: const TextStyle(color: darkFontGrey),
          ),
          showDone
              ? const Icon(
                  Icons.done,
                  color: redColor,
                )
              : Container()
        ],
      ),
    ),
  );
}
