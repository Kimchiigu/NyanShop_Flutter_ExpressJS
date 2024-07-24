import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("NyanShop"),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text("Login Page"),
              const TextField(
                decoration: InputDecoration(hintText: "Username"),
              ),
              CheckboxListTile(
                title: const Text("Agree?"),
                value: isAgree,
                onChanged: (value) {
                  setState(() {
                    isAgree = value!; // tanda ! kasitau bahwa gabakal null
                  });
                },
              )
            ],
          ),
        ));
  }
}
