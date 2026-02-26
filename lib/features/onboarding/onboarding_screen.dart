import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/tactile_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      context.go('/map');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 448),
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: const BoxDecoration(
            color: AppColors.surface,
          ),
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 24),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => context.go('/map'),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.fredoka(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              // Main content area
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildStep(_step),
                ),
              ),
              // Bottom: indicators + CTA
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                color: AppColors.surface,
                child: Column(
                  children: [
                    // Step indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        final isActive = i == _step;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: isActive ? 32 : 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: TactileButton(
                        onTap: _next,
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
                              style: GoogleFonts.fredoka(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: AppColors.textMain,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return _StepGhostBuses(key: const ValueKey(0));
      case 1:
        return _StepReportEarn(key: const ValueKey(1));
      case 2:
        return _StepPermissions(key: const ValueKey(2));
      default:
        return const SizedBox.shrink();
    }
  }
}

class _StepGhostBuses extends StatelessWidget {
  const _StepGhostBuses({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final illustrationSize = (screenWidth * 0.55).clamp(0.0, 224.0);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Blur bg
              Container(
                width: illustrationSize,
                height: illustrationSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.info.withValues(alpha: 0.1),
                ),
              ),
              // Image card
              Transform.rotate(
                angle: 0.05,
                child: Container(
                  width: illustrationSize,
                  height: illustrationSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.backgroundLight,
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(offset: Offset(0, 6), color: Color(0xFFE5E7EB)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      'https://picsum.photos/seed/bus/400/400',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.info.withValues(alpha: 0.1),
                        child: const Icon(Icons.directions_bus,
                            size: 64, color: AppColors.info),
                      ),
                    ),
                  ),
                ),
              ),
              // Location pin badge
              Positioned(
                top: -8,
                right: 12,
                child: Transform.rotate(
                  angle: 0.2,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 4),
                          color: Color(0x26000000),
                        ),
                      ],
                    ),
                    child:
                        const Icon(Icons.location_on, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
              children: [
                const TextSpan(text: 'No More\n'),
                TextSpan(
                  text: 'Ghost Buses',
                  style: GoogleFonts.fredoka(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'See real-time bus locations reported by the Hive. Know exactly when to step out.',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepReportEarn extends StatelessWidget {
  const _StepReportEarn({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final illustrationSize = (screenWidth * 0.55).clamp(0.0, 224.0);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: illustrationSize,
                height: illustrationSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              Transform.rotate(
                angle: -0.03,
                child: Container(
                  width: illustrationSize,
                  height: illustrationSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.backgroundLight,
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(offset: Offset(0, 6), color: Color(0xFFE5E7EB)),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 6),
                              blurRadius: 12,
                              color: Color(0x33000000),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.savings,
                          size: 40,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '+50 Nectar',
                          style: GoogleFonts.fredoka(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -8,
                left: -8,
                child: Transform.rotate(
                  angle: -0.1,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 4),
                          color: Color(0x26000000),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.military_tech,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
              children: [
                const TextSpan(text: 'Report &\n'),
                TextSpan(
                  text: 'Earn Rewards',
                  style: GoogleFonts.fredoka(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Spot a bus? Drop a pin to help the community. Level up and earn badges!',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepPermissions extends StatelessWidget {
  const _StepPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
              children: [
                const TextSpan(text: 'Enable Your\n'),
                TextSpan(
                  text: 'Senses',
                  style: GoogleFonts.fredoka(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'To make the Hive work for you, we need a couple of permissions.',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          _PermissionTile(
            icon: Icons.near_me,
            iconColor: AppColors.info,
            title: 'Location',
            subtitle: 'To show nearby buses & stops',
            isEnabled: false,
          ),
          const SizedBox(height: 16),
          _PermissionTile(
            icon: Icons.notifications_active,
            iconColor: AppColors.accent,
            title: 'Alerts',
            subtitle: 'Get notified when your bus is near',
            isEnabled: true,
          ),
          const SizedBox(height: 12),
          Text(
            'You can change these later in settings.',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontSize: 11,
              color: AppColors.textMuted.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionTile extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isEnabled;

  const _PermissionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isEnabled,
  });

  @override
  State<_PermissionTile> createState() => _PermissionTileState();
}

class _PermissionTileState extends State<_PermissionTile> {
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = widget.isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(offset: Offset(0, 2), color: Color(0x1A000000)),
              ],
            ),
            child: Icon(widget.icon, color: widget.iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _enabled,
            onChanged: (v) => setState(() => _enabled = v),
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}
