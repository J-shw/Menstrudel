import 'package:flutter/material.dart';

class MainNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onScreenSelected;
  
  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onScreenSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      surfaceTintColor: Colors.white,
      elevation: 2.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.bar_chart,
            label: 'Insights',
            isActive: selectedIndex == 0,
            onPressed: () => onScreenSelected(0),
          ),
          _NavBarItem(
            icon: Icons.book,
            label: 'Logs',
            isActive: selectedIndex == 1,
            onPressed: () => onScreenSelected(1),
          ),
          _NavBarItem(
            icon: Icons.medication_rounded,
            label: 'Pill',
            isActive: selectedIndex == 2,
            onPressed: () => onScreenSelected(2),
          ), 
          _NavBarItem(
            icon: Icons.settings,
            label: 'Settings',
            isActive: selectedIndex == 2,
            onPressed: () => onScreenSelected(2),
          ), 
        ],
      )
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Theme.of(context).primaryColor : Colors.grey;
    return InkWell(
      onTap: isActive ? null : onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}