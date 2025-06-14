import 'package:flutter/material.dart';

class UTC2Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.yellow[800]!, width: 2),
      ),
      child: Icon(
        Icons.school,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
