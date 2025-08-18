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
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
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
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (widget.isActive) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant _NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pillColor = theme.colorScheme.primary;
    final activeIconColor = theme.colorScheme.onPrimary;
    final inactiveColor = Colors.grey;

    return GestureDetector(
      onTap: widget.isActive ? null : widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 58.0,
              height: 34.0,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final pillWidth =
                      _controller.status == AnimationStatus.reverse
                          ? 58.0
                          : 58.0 * _animation.value;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: _animation.value,
                        child: Container(
                          width: pillWidth,
                          height: 34.0,
                          decoration: BoxDecoration(
                            color: pillColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      child!,
                    ],
                  );
                },
                child: Icon(
                  widget.isActive ? widget.iconActive : widget.iconInactive,
                  color: widget.isActive ? activeIconColor : inactiveColor,
                  size: 26,
                ),
              ),
            ),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.isActive ? theme.primaryColor : inactiveColor,
                fontSize: 12,
                fontWeight:
                    widget.isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}