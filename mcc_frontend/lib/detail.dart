import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final String userId; // Add userId as a parameter

  const DetailPage(
      {super.key,
      required this.item,
      required this.userId}); // Add userId to constructor

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _reviewController = TextEditingController();
  List<Map<String, dynamic>> _reviews = [];
  bool isLoadingReviews = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchReviews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _fetchReviews() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/reviews/get/${widget.item['id']}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _reviews = data.cast<Map<String, dynamic>>();
          isLoadingReviews = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load reviews';
          isLoadingReviews = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error occurred: $e';
        isLoadingReviews = false;
      });
    }
  }

  void _addReview() async {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review cannot be empty')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/reviews/create'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'itemId': widget.item['id'],
          'review_text': _reviewController.text,
          'userId': widget.userId, // Send userId
        }),
      );

      if (response.statusCode == 201) {
        _reviewController.clear();
        _fetchReviews();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit review')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['name']),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: "Details"),
            Tab(icon: Icon(Icons.comment), text: "Reviews"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Product Details
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    widget.item['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.item['name'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.item['description'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${widget.item['price']}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      labelText: 'Leave a review',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addReview,
                    child: const Text('Submit Review'),
                  ),
                ],
              ),
            ),
          ),
          // Tab 2: Reviews
          isLoadingReviews
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: _reviews.length,
                        itemBuilder: (context, index) {
                          final review = _reviews[index];
                          return ListTile(
                            title: Text(review['username'] ?? 'Anonymous'),
                            subtitle: Text(review['review_text'] ?? ''),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
