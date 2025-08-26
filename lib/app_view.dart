import 'package:expense_tracker/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.grey.shade100,
          onSurface: Colors.black87,
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFFE064F7),
          tertiary: Color(0xFFFF8D6C),
          outline: Colors.grey,
          surfaceDim: Color(0xFFF2F2F2),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
