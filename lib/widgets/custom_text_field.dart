import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool isDatePicker;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.isDatePicker = false,
    this.controller,
    this.keyboardType,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(widget.prefixIcon, color: Colors.grey[600]),
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : widget.isDatePicker
              ? Icon(Icons.calendar_today, color: Colors.grey[600])
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}