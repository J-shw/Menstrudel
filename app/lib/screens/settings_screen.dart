import 'package:flutter/material.dart';
import 'package:menstrudel/widgets/navigation_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Text(
          "Settings Screen"
        ),
      ),
      bottomNavigationBar: MainBottomNavigationBar(isSettingScreenActive: true,),
    );
  }
}