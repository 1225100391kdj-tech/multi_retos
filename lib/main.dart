
import 'package:flutter/material.dart';
import 'pantallas/menu_principal.dart';

void main() {
  runApp(const MultiRetosApp());
}

class MultiRetosApp extends StatelessWidget {
  const MultiRetosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MultiRetos',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F5FC),
      ),
      home: const MenuPrincipal(),
    );
  }
}
