import 'dart:ui';
import 'package:flutter/cupertino.dart';


import '../../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onpressed;

  const CustomButton({
    required this.title,
    required this.bgColor,
    required this.textColor,
    required this.onpressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        width: w * 0.4,
        child: Center(
            child: Text(title, style: TextStyle(color: textColor)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: bgColor,
          border: Border.all(color: Mycolors.mainColor, width: 1),
        ),
      ),
    );
  }
}