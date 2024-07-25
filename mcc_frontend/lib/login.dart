import 'package:flutter/material.dart';
import 'package:mcc_frontend/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? usernameError;
  String? emailError;
  String? passwordError;

  void handleLogin() {
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

    // Basic email validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      emailError = "Please enter a valid email address";
      hasError = true;
    } else {
      emailError = null;
    }

    // Basic password validation
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

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return HomePage(username: usernameController.text);
    }), (route) => false);
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
                'nyanshop-logo.png',
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
                onPressed: handleLogin,
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
