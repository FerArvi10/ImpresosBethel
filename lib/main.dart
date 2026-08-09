import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const OrderTrackerApp());
}

class OrderTrackerApp extends StatelessWidget {
  const OrderTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrderTracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
