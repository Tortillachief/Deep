import 'package:flutter/material.dart';

class DeepButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const DeepButton({
    super.key, 
    required this.onPressed, 
    this.icon = Icons.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.0),
            onTap: onPressed,
            child: Center(
              child: Icon(
                icon,
                color: Colors.black,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}