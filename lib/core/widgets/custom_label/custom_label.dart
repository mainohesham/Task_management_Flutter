import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';


class MyLabel extends StatelessWidget {
  final String text;

  const MyLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 200),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: Mycolors.mainColor,
        ),
      ),
    );
  }
}
