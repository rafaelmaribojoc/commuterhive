import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sheetController;
  late final Animation<Offset> _sheetSlide;
  bool _sheetVisible = true;

  @override
  void initState() {
    super.initState();
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sheetSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1.5),
    ).animate(CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _hideSheet() {
    _sheetController.forward();
    setState(() => _sheetVisible = false);
  }

  void _showSheet() {
    _sheetController.reverse();
    setState(() => _sheetVisible = true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map background (placeholder until real MapBox token)
        Positioned.fill(child: _MapPlaceholder()),

        // UI Overlays
        Positioned.fill(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Search bar + avatar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Row(
                    children: [
                      // Search bar
                      Expanded(
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 6),
                                color: Color(0xFFE5E7EB),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              const Icon(Icons.search,
                                  color: AppColors.textMuted, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  style: GoogleFonts.fredoka(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textMain,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Where are you heading?',
                                    hintStyle: GoogleFonts.fredoka(
                                      fontWeight: FontWeight.w500,
                                      color:
                                          AppColors.textMuted.withValues(alpha: 0.7),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 24,
                                color: Colors.grey.shade100,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.mic,
                                    color: AppColors.primaryDark),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Avatar button
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 6),
                              color: Color(0xFFE5E7EB),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            'https://picsum.photos/seed/avatar/200/200',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Filter pills
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _FilterPill(
                        label: 'Nearby',
                        icon: Icons.near_me,
                        isActive: true,
                      ),
                      _FilterPill(label: 'Favorites'),
                      _FilterPill(label: 'Davao Loop'),
                      _FilterPill(label: 'Toril Exp'),
                    ],
                  ),
                ),
                // Spacer
                const Spacer(),
              ],
            ),
          ),
        ),

        // Floating buttons (layers + my location)
        Positioned(
          right: 20,
          bottom: MediaQuery.of(context).size.height * 0.38,
          child: Column(
            children: [
              _FloatButton(
                icon: Icons.layers,
                color: AppColors.textMain,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _FloatButton(
                icon: Icons.my_location,
                color: AppColors.info,
                onTap: () {},
              ),
              // Show route info button (visible when sheet is hidden)
              if (!_sheetVisible) ...[
                const SizedBox(height: 16),
                _FloatButton(
                  icon: Icons.directions_bus,
                  color: AppColors.primaryDark,
                  onTap: _showSheet,
                ),
              ],
            ],
          ),
        ),

        // Bottom info sheet
        Positioned(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).size.height * 0.12,
          child: SlideTransition(
            position: _sheetSlide,
            child: _RouteInfoSheet(onDismiss: _hideSheet),
          ),
        ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isActive;

  const _FilterPill({
    required this.label,
    this.icon,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: isActive ? AppColors.textMain : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: Colors.black12,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 18,
                    color: isActive ? Colors.white : AppColors.textMain,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : AppColors.textMain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FloatButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
      shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: color),
        ),
      ),
    );
  }
}

class _RouteInfoSheet extends StatelessWidget {
  final VoidCallback onDismiss;

  const _RouteInfoSheet({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 32,
            color: Color(0x1F2D2345),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle — tap or drag down to dismiss
          GestureDetector(
            onTap: onDismiss,
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity! > 100) {
                onDismiss();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Davao Loop',
                      style: GoogleFonts.fredoka(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Arriving in ~4 mins',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textMuted,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: GoogleFonts.fredoka(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.info,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Reporter avatars
                  SizedBox(
                    width: 60,
                    height: 24,
                    child: Stack(
                      children: [
                        _miniAvatar(0, 'rep1'),
                        _miniAvatar(16, 'rep2'),
                        Positioned(
                          left: 32,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                '+3',
                                style: GoogleFonts.fredoka(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Current load bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade100.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(offset: Offset(0, 2), color: Color(0x1A000000)),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_bus,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'CURRENT LOAD',
                              style: GoogleFonts.fredoka(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Standing Room',
                              style: GoogleFonts.fredoka(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primary,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // View schedule button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View Full Schedule',
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_month,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniAvatar(double left, String seed) {
    return Positioned(
      left: left,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: ClipOval(
          child: Image.network(
            'https://picsum.photos/seed/$seed/200/200',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFDFDFC),
      child: Stack(
        children: [
          // Grid background
          CustomPaint(
            size: Size.infinite,
            painter: _MapGridPainter(),
          ),
          // Green land patches
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.05,
            child: Transform.rotate(
              angle: 0.2,
              child: Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7EF),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            right: -MediaQuery.of(context).size.width * 0.05,
            child: Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                color: Color(0xFFE0F7EF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Route lines
          CustomPaint(
            size: Size.infinite,
            painter: _RouteLinesPainter(),
          ),
          // Bus markers
          _BusMarker(
            top: 0.35,
            left: 0.25,
            color: AppColors.success,
            label: 'EMPTY',
          ),
          _BusMarker(
            top: 0.6,
            left: 0.65,
            color: AppColors.primary,
            label: 'STANDING',
          ),
          _BusMarker(
            top: 0.15,
            left: 0.8,
            color: AppColors.accent,
            label: 'FULL',
          ),
          // User location dot
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.info.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.info,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 8,
                        color: Color(0x33000000),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BusMarker extends StatelessWidget {
  final double top;
  final double left;
  final Color color;
  final String label;

  const _BusMarker({
    required this.top,
    required this.left,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height * top,
      left: size.width * left,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: color, width: 3),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 8,
                  color: Color(0x33000000),
                ),
              ],
            ),
            child: Icon(Icons.directions_bus, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(offset: Offset(0, 2), color: Color(0x1A000000)),
              ],
            ),
            child: Text(
              label,
              style: GoogleFonts.fredoka(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEEEEEE)
      ..strokeWidth = 2;
    const spacing = 100.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RouteLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.info.withValues(alpha: 0.8)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(-50, 200)
      ..quadraticBezierTo(150, 250, 180, 400)
      ..quadraticBezierTo(250, 550, 450, 700);
    canvas.drawPath(path1, paint);

    final paint2 = Paint()
      ..color = AppColors.info.withValues(alpha: 0.6)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path2 = Path()
      ..moveTo(100, -50)
      ..quadraticBezierTo(120, 300, 300, 450)
      ..quadraticBezierTo(400, 550, 600, 600);
    canvas.drawPath(path2, paint2);

    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, 500), Offset(500, 300), road);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
