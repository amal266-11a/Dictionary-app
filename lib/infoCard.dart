import 'package:flutter/material.dart';

class infoCard extends StatelessWidget {
  final String title;
  final String value;
 
  final bool isItalic;
   infoCard({
    required this.title,
    required this.value,
    
    this.isItalic = false,});

  @override
  Widget build(BuildContext context) {
    return  Container(
  width: double.infinity,
  padding: EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 105, 1, 137),
    borderRadius: BorderRadius.circular(20),
  ), // BoxDecoration
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: const Color.fromARGB(255, 225, 189, 247),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ), // TextStyle
      ), // Text
      Text(value,style: TextStyle(color: const Color.fromARGB(255, 225, 189, 247)),),
    ],
  ), // Column
);
  }
}