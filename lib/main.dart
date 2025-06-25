import 'package:flutter/material.dart';
import 'default_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: Scaffold(
        backgroundColor: Colors.white,
        
        
        body: DefaultPage(),

        
        
      ),
    );
  }
}
