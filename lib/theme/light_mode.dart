import 'package:flutter/material.dart';


ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade200,
    onPrimary: Colors.grey.shade800, // Assuming you want dark text/icons on light primary.
    secondary: Colors.grey.shade400,
    onSecondary: Colors.grey.shade600, // Adjust as needed for contrast on secondary.
  ),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.grey[800],
    displayColor: Colors.black,
  ),
);
