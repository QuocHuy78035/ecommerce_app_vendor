import 'package:flutter/material.dart';

showSnackBar(context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.yellow.shade900,
      content: Text(title),
    ),
  );
}
