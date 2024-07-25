import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkMode = false;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  void _toggleTheme(String? value) {
    setState(() {
      isDarkMode = value == 'Dark';
    });
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoSlide();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NyanShop"),
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Greeting Message
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hello ${widget.username}!',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          // Image Carousel with Arrows
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  children: [
                    Image.asset('event-1.png', fit: BoxFit.cover),
                    Image.asset('event-2.png', fit: BoxFit.cover),
                    Image.asset('event-3.png', fit: BoxFit.cover),
                  ],
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Infographic
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About NyanShop',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 10),
                Text(
                  'NyanShop is a leading online store offering a wide range of products. Our mission is to provide the best shopping experience with high-quality products and exceptional customer service. Whether you are looking for the latest fashion trends, electronics, or home essentials, NyanShop has it all. Stay tuned for exciting promotions and updates!',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ],
      ),
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
        currentIndex: 0, // Update to reflect current selected index
        onTap: (index) {
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
        },
      ),
    );
  }
}
