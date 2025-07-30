import 'package:flutter/material.dart';
import 'package:menstrudel/screens/analytics_screen.dart';

class MainBottomNavigationBar extends StatelessWidget {
  
  const MainBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.bar_chart, size: 30.0),
                  tooltip: 'Logs',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AnalyticsScreen(),
                      ),
                    );
                  },
                ),	
              ],
            ),
            const SizedBox(width: 48.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // IconButton(
                // 	icon: const Icon(Icons.settings, size: 30.0),
                // 	tooltip: 'Settings',
                // 	onPressed: () {
                    
                // 	},
                // ),	
              ],
            ),
          ],
        )
      ),
    );
  }
}