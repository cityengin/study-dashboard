import 'package:flutter/material.dart';

class DemoLabScreen extends StatelessWidget {
  const DemoLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Lab'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Demo Lab'),
      ),
    );
  }
}
