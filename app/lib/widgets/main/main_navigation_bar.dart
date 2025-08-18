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
            iconActive: Icons.bar_chart_rounded,
            iconInactive: Icons.bar_chart_sharp,
            label: 'Insights',
            isActive: selectedIndex == 0,
            onPressed: () => onScreenSelected(0),
          ),
          _NavBarItem(
            iconActive: Icons.book,
            iconInactive: Icons.book_outlined,
            label: 'Logs',
            isActive: selectedIndex == 1,
            onPressed: () => onScreenSelected(1),
          ),
          _NavBarItem(
            iconActive: Icons.medication_rounded,
            iconInactive: Icons.medication_outlined,
            label: 'Pill',
            isActive: selectedIndex == 2,
            onPressed: () => onScreenSelected(2),
          ), 
          _NavBarItem(
            iconActive: Icons.settings,
            iconInactive: Icons.settings_outlined,
            label: 'Settings',
            isActive: selectedIndex == 3,
            onPressed: () => onScreenSelected(3),
          ), 
        ],
      )
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData iconActive;
  final IconData iconInactive;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const _NavBarItem({
    required this.iconActive,
    required this.iconInactive,
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
            if (isActive)
              Icon(iconActive, color: color, size: 26)
            else
              Icon(iconInactive, color: color, size: 26),
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