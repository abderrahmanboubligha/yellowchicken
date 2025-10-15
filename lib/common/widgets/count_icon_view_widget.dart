import 'package:flutter/material.dart';

class CountIconView extends StatelessWidget {
  final String count;
  final IconData icon;
  final Color color;
  final double? size;

  const CountIconView({
    super.key,
    required this.count,
    required this.icon,
    required this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          icon,
          color: color,
          size: size ?? 24,
        ),
        if (count != '0')
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
