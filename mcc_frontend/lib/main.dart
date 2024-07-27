import 'package:flutter/material.dart';
import 'package:mcc_frontend/home.dart';
import 'package:mcc_frontend/item.dart';
import 'package:mcc_frontend/login.dart';
import 'package:mcc_frontend/profile.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'NyanShop',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(userId: 1),
        '/items': (context) => const ItemPage(userId: 1),
        '/profile': (context) => ProfilePage(
            userId: 1, username: 'Guest', navigatorKey: navigatorKey),
      },
    );
  }
}
