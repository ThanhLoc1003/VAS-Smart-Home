import 'package:flutter/material.dart';

import '../style.dart';

Widget platformAppBar(
  Style style, {
  String? title,
  List<Widget>? trailingActions,
}) {
  Text? titleText = title != null ? Text(title) : null;
  return AppBar(title: titleText, actions: trailingActions);
}
