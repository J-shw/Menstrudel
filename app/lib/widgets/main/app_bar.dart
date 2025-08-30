import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String titleText;
  
  const TopAppBar({
    super.key,
    this.titleText = "Menstrudel",
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
              titleText,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(35),
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}