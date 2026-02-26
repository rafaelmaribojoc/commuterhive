import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class TactileButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double shadowOffset;

  const TactileButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = AppColors.primary,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.shadowOffset = 4,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          _isPressed ? widget.shadowOffset : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, _isPressed ? 0 : widget.shadowOffset),
              color: Colors.black.withValues(alpha: 0.15),
            ),
          ],
        ),
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}
