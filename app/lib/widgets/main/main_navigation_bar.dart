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
  final theme = Theme.of(context);
  final color = isActive ? theme.primaryColor : Colors.grey;
  final pillColor = theme.colorScheme.primary;
  
  final activeIconColor = theme.colorScheme.onPrimary; 
  final inactiveColor = Colors.grey;

  const pillPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 4);

  return InkWell(
    onTap: isActive ? null : onPressed,
    borderRadius: BorderRadius.circular(20),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive)
            Container(
              padding: pillPadding,
              decoration: BoxDecoration(
                color: pillColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(iconActive, color: activeIconColor, size: 26),
            )
          else
            Container(
              padding: pillPadding,
              child: Icon(iconInactive, color: inactiveColor, size: 26),
            ),
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