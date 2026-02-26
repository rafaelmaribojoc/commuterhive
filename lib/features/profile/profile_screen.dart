import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/hexagon_badge.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          children: [
            _ProfileHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatsGrid(),
                  const SizedBox(height: 24),
                  _BadgesSection(),
                  const SizedBox(height: 24),
                  _RecentActivity(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          children: [
            // Settings button
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: const [
                    BoxShadow(offset: Offset(0, 4), color: Color(0x26000000)),
                  ],
                ),
                child: const Icon(Icons.settings, color: AppColors.textMain),
              ),
            ),
            // Avatar with XP ring
            SizedBox(
              width: 116,
              height: 116,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Progress ring
                  SizedBox(
                    width: 116,
                    height: 116,
                    child: CustomPaint(painter: _XpRingPainter(progress: 0.75)),
                  ),
                  // Avatar
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 2),
                          color: Color(0x1A000000),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://picsum.photos/seed/avatar/200/200',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  // Level badge
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 2),
                            color: Color(0x1A000000),
                          ),
                        ],
                      ),
                      child: Text(
                        'Level 4',
                        style: GoogleFonts.fredoka(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Scout Sarah',
              style: GoogleFonts.fredoka(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            Text(
              'Davao City Explorer',
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _XpRingPainter extends CustomPainter {
  final double progress;

  _XpRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 6.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background ring
    final bgPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    final fgPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -1.5708; // -90 degrees
    final sweepAngle = progress * 2 * 3.14159;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _XpRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _StatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = (constraints.maxWidth - 16) / 2;
        final cellHeight = cellWidth * 0.85;
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: cellWidth / cellHeight,
          children: const [
            _StatCard(
              icon: Icons.campaign,
              iconBgColor: Color(0x1A4C6FFF),
              iconColor: AppColors.info,
              value: '124',
              label: 'REPORTS',
            ),
            _StatCard(
              icon: Icons.verified_user,
              iconBgColor: Color(0x1A00C896),
              iconColor: AppColors.success,
              value: '98%',
              label: 'TRUST SCORE',
            ),
            _StatCard(
              icon: Icons.hive,
              iconBgColor: Color(0x33FFD600),
              iconColor: AppColors.primaryDark,
              value: '2,450',
              label: 'NECTAR',
            ),
            _StatCard(
              icon: Icons.group,
              iconBgColor: Color(0x1AFF4785),
              iconColor: AppColors.accent,
              value: '3.2k',
              label: 'IMPACT',
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 6), color: Color(0xFFE5E7EB)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.fredoka(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Badges',
              style: GoogleFonts.fredoka(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View All',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.info,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              _BadgeItem(
                label: 'Early Bird',
                icon: Icons.wb_twilight,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFD600), Color(0xFFFF4785)],
                ),
                isLocked: false,
              ),
              const SizedBox(width: 16),
              _BadgeItem(
                label: 'Line Savior',
                icon: Icons.health_and_safety,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4C6FFF), Color(0xFF9333EA)],
                ),
                isLocked: false,
              ),
              const SizedBox(width: 16),
              _BadgeItem(
                label: 'Night Owl',
                icon: Icons.nightlight,
                isLocked: true,
              ),
              const SizedBox(width: 16),
              _BadgeItem(
                label: 'Hot Streak',
                icon: Icons.local_fire_department,
                isLocked: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Gradient? gradient;
  final bool isLocked;

  const _BadgeItem({
    required this.label,
    required this.icon,
    this.gradient,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Column(
        children: [
          HexagonBadge(
            size: 80,
            gradient: isLocked ? null : gradient,
            backgroundColor: isLocked ? Colors.grey.shade200 : null,
            isLocked: isLocked,
            child: isLocked
                ? Icon(icon, color: Colors.grey.shade400, size: 36)
                : Icon(icon, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isLocked ? AppColors.textMuted : AppColors.textMain,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
        ),
        const SizedBox(height: 12),
        _ActivityCard(
          icon: Icons.directions_bus,
          iconBgColor: AppColors.info.withValues(alpha: 0.1),
          iconColor: AppColors.info,
          title: 'Davao Loop',
          subtitle: 'Reported: Standing Room Only',
          time: '2h ago',
          likes: 12,
        ),
        const SizedBox(height: 12),
        _ActivityCard(
          icon: Icons.check_circle,
          iconBgColor: AppColors.success.withValues(alpha: 0.1),
          iconColor: AppColors.success,
          title: 'Toril Express',
          subtitle: 'Verified location accuracy',
          time: 'Yesterday',
          likes: 5,
        ),
        const SizedBox(height: 12),
        _ActivityCard(
          icon: Icons.add_location,
          iconBgColor: AppColors.primary.withValues(alpha: 0.2),
          iconColor: AppColors.primaryDark,
          title: 'Airport Shuttle',
          subtitle: 'Reported: Plenty of Seats',
          time: '2d ago',
          likes: 8,
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final int likes;

  const _ActivityCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 6), color: Color(0xFFE5E7EB)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBgColor,
              border: Border.all(
                color: iconColor.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.fredoka(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey.shade100),
              ),
            ),
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.favorite,
                  size: 16,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 4),
                Text(
                  '$likes',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
