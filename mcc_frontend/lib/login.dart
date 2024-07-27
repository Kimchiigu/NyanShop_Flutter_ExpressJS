import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mcc_frontend/layout.dart';
import 'package:mcc_frontend/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  Future<void> handleLogin() async {
    String email = emailController.text;
    String password = passwordController.text;

    bool hasError = false;

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        emailError = "Please enter a valid email address";
      });
      hasError = true;
    } else {
      setState(() {
        emailError = null;
      });
    }

    // Password validation
    if (password.length < 6) {
      setState(() {
        passwordError = "Password must be at least 6 characters long";
      });
      hasError = true;
    } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(password)) {
      // Check for at least one letter and one number
      setState(() {
        passwordError = "Password must contain both letters and numbers";
      });
      hasError = true;
    } else {
      setState(() {
        passwordError = null;
      });
    }

    if (hasError) {
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://10.0.2.2:3000/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['id'] != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LayoutPage(userId: data['id']),
            ),
          );
        } else {
          print("User ID is missing in the response");
        }
      } else {
        print("Login failed: ${response.body}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  void navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NyanShop"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/nyanshop-logo.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                "Login Page",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
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
                onPressed: handleLogin,
                child: const Text("Login"),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: navigateToRegister,
                child: const Text(
                  "Don't have an account yet? Register here",
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
