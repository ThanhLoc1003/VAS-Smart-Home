import 'package:flutter/material.dart';

import '../style.dart';

class PlatformSearchBar extends StatelessWidget {
  final Style style;
  final String hint;
  final TextEditingController? controller;

  const PlatformSearchBar({
    super.key,
    this.style = Style.material,
    this.hint = 'Search',
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: hint,
      controller: controller,
    );
  }
}
