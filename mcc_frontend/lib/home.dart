import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkMode = false;
  late PageController _pageController;
  int _currentPage = 0;
  String? username;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _pageController = PageController();
    _startAutoSlide();
  }

  void _fetchUsername() async {
    try {
      var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/users/get/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("Fetched data: $data");
        setState(() {
          if (data is List && data.isNotEmpty) {
            username = data[0]['username'];
          } else {
            print("User data is empty or not in expected format");
          }
        });
      } else {
        print("Failed to fetch username: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
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
        title: const Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Hello ${username ?? 'Guest'}!',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    children: [
                      Image.asset('assets/event-1.png', fit: BoxFit.cover),
                      Image.asset('assets/event-2.png', fit: BoxFit.cover),
                      Image.asset('assets/event-3.png', fit: BoxFit.cover),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Welcome to NyanShop! At NyanShop, we're passionate about all things feline. We specialize in providing a curated selection of premium cat products and comprehensive cat maintenance solutions to ensure your furry friends are happy and healthy.",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/nyanshop-infographic.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
