import 'package:Respawnd/ui/constants.dart';
import 'package:flutter/material.dart';

Widget genderWidget(icon, text, size, selected, onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: <Widget>[
        Icon(
          icon,
          size: size.height * 0.05,
          color: selected == text ? colorRed : Colors.black54,
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Text(
          text,
          style: TextStyle(
            color: selected == text ? colorRed : Colors.black,
            fontSize: size.width * 0.04,
          ),
        ),
      ],
    ),
  );
}
