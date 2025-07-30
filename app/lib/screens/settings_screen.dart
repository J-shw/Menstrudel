import 'package:flutter/material.dart';
import 'package:menstrudel/widgets/navigation_bar.dart';
import 'package:menstrudel/widgets/app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        titleText: "Settings"
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