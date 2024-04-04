import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: Center(
        child: Text(
          "Cargando...",
          style: TextStyle(
              fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
