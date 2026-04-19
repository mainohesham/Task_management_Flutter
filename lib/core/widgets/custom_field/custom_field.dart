import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';


class CustomField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final bool obscureText;
  final double width;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType; // ✅ added

  //attributes for focusnode
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;


  const CustomField({
    super.key,
    required this.hintText,
    required this.icon,
    this.controller,
    this.obscureText = false,
    this.width = 315,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.keyboardType, // ✅ added
  });

  @override
  CustomFieldState createState() => CustomFieldState();
}

class CustomFieldState extends State<CustomField> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _passwordVisible,
        validator: widget.validator,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        keyboardType: widget.keyboardType, // ✅ added
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 6,
          ),
          prefixIcon: Icon(widget.icon, color: Mycolors.mainColor),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Mycolors.textColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Mycolors.mainColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Mycolors.mainColor,
              width: 1.3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Mycolors.mainColor,
              width: 2,
            ),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              _passwordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Mycolors.mainColor,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}