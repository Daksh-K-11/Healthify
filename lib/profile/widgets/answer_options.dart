import 'package:flutter/material.dart';
import 'package:healthify/core/theme/pallete.dart';

class AnswerOption extends StatefulWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<AnswerOption> createState() => _AnswerOptionState();
}

class _AnswerOptionState extends State<AnswerOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Pallete.gradient1.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  widget.isSelected ? Pallete.gradient1 : Pallete.borderColor,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (widget.isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Pallete.gradient1,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
