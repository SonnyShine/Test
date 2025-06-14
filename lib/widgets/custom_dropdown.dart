import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.selectedValue,
  }) : super(key: key);

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
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(prefixIcon, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}