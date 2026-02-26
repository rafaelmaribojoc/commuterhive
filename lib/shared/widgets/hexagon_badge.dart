import 'package:flutter/material.dart';

class HexagonBadge extends StatelessWidget {
  final Widget child;
  final double size;
  final Gradient? gradient;
  final Color? backgroundColor;
  final bool isLocked;

  const HexagonBadge({
    super.key,
    required this.child,
    this.size = 80,
    this.gradient,
    this.backgroundColor,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipPath(
        clipper: _HexagonClipper(),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: gradient,
                color: gradient == null
                    ? (backgroundColor ?? Colors.grey.shade200)
                    : null,
              ),
              child: Center(child: child),
            ),
            if (isLocked)
              Container(
                color: Colors.black.withValues(alpha: 0.05),
                child: const Center(
                  child: Icon(Icons.lock, color: Colors.grey, size: 24),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(w * 0.5, 0);
    path.lineTo(w, h * 0.25);
    path.lineTo(w, h * 0.75);
    path.lineTo(w * 0.5, h);
    path.lineTo(0, h * 0.75);
    path.lineTo(0, h * 0.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
