import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildTime(DateTime date, Size size) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      const SizedBox(
        height: 6.0,
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 6.0, left: 28.0),
        child: Text(
          DateFormat('hh:mm:ss').format(date),
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      Text(
        Jiffy.parseFromList([date.year, date.month, date.day]).yMMMMd,
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
    ],
  );
}
