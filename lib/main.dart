import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const IteganyagiheApp());
}

class IteganyagiheApp extends StatelessWidget {
  const IteganyagiheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iteganyagihe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
