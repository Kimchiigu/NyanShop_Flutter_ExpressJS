import 'package:flutter/material.dart';
import 'package:mcc_frontend/login.dart';

void main(List<String> args) {
  runApp(const NyanShop());
}

class NyanShop extends StatelessWidget {
  const NyanShop({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "NyanShop",
      home: LoginPage(),
    );
  }
}
