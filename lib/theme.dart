import 'package:flutter/material.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),
);
