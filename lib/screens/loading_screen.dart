import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Productos', style: TextStyle(color: Colors.white),),
      ),
      body: const Center(
        child: CircularProgressIndicator(
          color: Colors.indigo,
        ),
      ),
    );
  }
}
