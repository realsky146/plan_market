import 'package:flutter/material.dart';
import 'features/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plan Market',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6E9B4C),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
