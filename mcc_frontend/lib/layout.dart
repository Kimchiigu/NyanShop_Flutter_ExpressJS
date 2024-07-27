import 'package:flutter/material.dart';
import 'package:mcc_frontend/main.dart';
import 'home.dart';
import 'item.dart';
import 'profile.dart';

class LayoutPage extends StatefulWidget {
  final int userId;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  LayoutPage({super.key, required this.userId});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int _selectedIndex = 0;
  bool isDarkMode = false;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(userId: widget.userId),
      ItemPage(userId: widget.userId),
      ProfilePage(
        userId: widget.userId,
        username: '',
        navigatorKey: navigatorKey,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleTheme(String? value) {
    setState(() {
      isDarkMode = value == 'Dark';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        headline5: TextStyle(color: Colors.black),
        headline6: TextStyle(color: Colors.black),
        bodyText2: TextStyle(color: Colors.black),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey[700],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[850],
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        headline5: TextStyle(color: Colors.white),
        headline6: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white70),
      ),
    );

    return MaterialApp(
      theme: isDarkMode ? darkTheme : lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NyanShop'),
          actions: [
            PopupMenuButton<String>(
              onSelected: _toggleTheme,
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'Light',
                    child: Text('Light Mode'),
                  ),
                  const PopupMenuItem(
                    value: 'Dark',
                    child: Text('Dark Mode'),
                  ),
                ];
              },
            ),
            // IconButton(
            //   icon: const Icon(Icons.logout),
            //   onPressed: () {
            //     Navigator.pushReplacementNamed(context, '/login');
            //   },
            // ),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
