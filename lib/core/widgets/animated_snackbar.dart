import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedSnackBarContent extends StatelessWidget {
  final String message;
  final bool isSuccess;

  const AnimatedSnackBarContent(
      {super.key, required this.message, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuad,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSuccess ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(isSuccess ? Icons.check_circle : Icons.error,
                      color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}