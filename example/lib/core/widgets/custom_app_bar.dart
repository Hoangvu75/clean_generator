import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    super.key,
    Widget? title,
  }) : super(
          title: title,
          centerTitle: true,
          forceMaterialTransparency: true,
        );
}
