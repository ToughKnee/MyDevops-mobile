import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: true,
      ),
      body: const Center(
        child: Text(
          'Settings screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}