import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  final String title;
  final Widget child;
  final bool isDarkMode;
  final ValueChanged<String?> onThemeChanged;

  const MainLayout({
    super.key,
    required this.title,
    required this.child,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/items');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            PopupMenuButton<String>(
              onSelected: widget.onThemeChanged,
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
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
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
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
