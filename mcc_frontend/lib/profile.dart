import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatelessWidget {
  final int userId;
  final GlobalKey<NavigatorState> navigatorKey;

  const ProfilePage({
    super.key,
    required this.userId,
    required String username,
    required this.navigatorKey,
  });

  Future<Map<String, dynamic>> fetchUserDetails() async {
    try {
      var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/users/get/$userId'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          return data[0]; // Return the first item in the list
        } else {
          throw Exception('User data is empty or not in expected format');
        }
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              var user = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: ${user['username']}'),
                  Text('Email: ${user['email']}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      navigatorKey.currentState?.pushReplacementNamed('/login');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No user data found'));
            }
          },
        ),
      ),
    );
  }
}
