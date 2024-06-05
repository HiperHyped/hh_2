import 'package:flutter/material.dart';
//import 'package:hh_2/src/config/common/var/hh_colors.dart';

class HHIconButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final VoidCallback onPressed;

  const HHIconButton({
    Key? key,
    required this.icon,
    this.iconSize = 20,
    this.iconColor = Colors.white,
    required this.onPressed,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
      padding: EdgeInsets.all(0),
    );
  }
}
