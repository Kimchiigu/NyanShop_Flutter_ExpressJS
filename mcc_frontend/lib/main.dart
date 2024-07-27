import 'package:flutter/material.dart';
import 'package:mcc_frontend/home.dart';
import 'package:mcc_frontend/item.dart';
import 'package:mcc_frontend/login.dart';
import 'package:mcc_frontend/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NyanShop',
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.light, // Change to ThemeMode.dark to use dark theme
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) =>
            const HomePage(userId: 1), // Update to actual username
        '/items': (context) => const ItemPage(userId: '',),
        '/profile': (context) => const ProfilePage(
              username: 'Guest',
              userId: 1,
            ), // Update to actual username
      },
    );
  }
}
