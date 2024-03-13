import 'package:flutter/material.dart';


ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    onPrimary: Colors.grey.shade200, // Use `onPrimary` for text/icon color on top of the primary color.
    secondary: Colors.grey.shade700,
    onSecondary: Colors.grey.shade300, // Adjusted for visibility on secondary color, if needed.
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.grey[300],
    displayColor: Colors.white,
  ),
);
