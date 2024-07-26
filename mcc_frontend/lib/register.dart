import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mcc_frontend/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? usernameError;
  String? emailError;
  String? passwordError;

  Future<void> handleRegister() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    bool hasError = false;

    if (username.length < 3) {
      usernameError = "Username must be more than 3 characters";
      hasError = true;
    } else {
      usernameError = null;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      emailError = "Please enter a valid email address";
      hasError = true;
    } else {
      emailError = null;
    }

    if (password.length < 6) {
      passwordError = "Password must be at least 6 characters long";
      hasError = true;
    } else {
      passwordError = null;
    }

    if (hasError) {
      setState(() {}); // Trigger UI update to show error messages
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://127.0.0.1:3000/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Registration success
        print("Registration successful");
        // You can navigate to the login page or show a success message
        navigateToLogin();
      } else {
        // Handle error response
        print("Registration failed: ${response.body}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'nyanshop-logo.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                "Register",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  errorText: usernameError,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: emailError,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: passwordError,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleRegister,
                child: const Text("Register"),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: navigateToLogin,
                child: const Text(
                  "Already have an account? Login here",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
