import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics View'),
      ),
      body: const Center(
        child: Text('This is the Analytics Screen!'),
      ),
    );
  }
}