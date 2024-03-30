import 'package:flutter/material.dart';
import '../constants.dart';

Widget buildDevice(Size size, var device) {
  return Container(
    height: size.height * 0.2,
    width: size.width * 0.8,
    decoration: BoxDecoration(
      color: kBgColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(3, 3),
        ),
        BoxShadow(
          color: Colors.white,
          blurRadius: 0,
          offset: Offset(-3, -3),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.01),
          Row(
            children: [
              Text(
                device,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
        ],
      ),
    ),
  );
}
