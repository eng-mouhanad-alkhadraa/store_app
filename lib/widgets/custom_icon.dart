import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    required this.icon,
    this.onPressed,
    this.color, 
    this.size = 28,  
  });

  final double? size;
  final IconData icon;
  final void Function()? onPressed;
  final Color? color; 

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: size,
        color: color, 
      ),
    );
  }
}

