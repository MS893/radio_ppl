import 'package:flutter/material.dart';
import 'dart:async';

import 'package:radio_ppl/theme.dart';
import 'home_page.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const HomePage(title: 'Entraînement radio à AIX',),
    );
  }

}
