import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../features/report/report_modal.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  static const _tabs = [
    _NavTab(icon: Icons.map_outlined, filledIcon: Icons.map, label: 'Map', route: '/map'),
    _NavTab(icon: Icons.directions_bus_outlined, filledIcon: Icons.directions_bus, label: 'Routes', route: '/routes'),
    _NavTab(icon: Icons.add, filledIcon: Icons.add, label: '', route: ''), // placeholder for FAB
    _NavTab(icon: Icons.leaderboard_outlined, filledIcon: Icons.leaderboard, label: 'Rank', route: '/rank'),
    _NavTab(icon: Icons.person_outline, filledIcon: Icons.person, label: 'Profile', route: '/profile'),
  ];

  void _onTap(BuildContext context, int index) {
    if (index == 2) {
      // Center FAB -> show report modal
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const ReportModal(),
      );
      return;
    }
    context.go(_tabs[index].route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -4),
            blurRadius: 20,
            color: Color(0x0D000000),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (i) {
              if (i == 2) {
                return _buildFab(context);
              }
              final isActive = currentIndex == i;
              final tab = _tabs[i];
              return _buildNavItem(
                context,
                icon: isActive ? tab.filledIcon : tab.icon,
                label: tab.label,
                isActive: isActive,
                onTap: () => _onTap(context, i),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context, 2),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 8),
              color: Color(0x26000000),
            ),
          ],
        ),
        child: const Icon(Icons.add, size: 32, color: AppColors.textMain),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isActive ? AppColors.backgroundLight : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 28,
              color: isActive ? AppColors.primaryDark : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isActive ? AppColors.textMain : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTab {
  final IconData icon;
  final IconData filledIcon;
  final String label;
  final String route;

  const _NavTab({
    required this.icon,
    required this.filledIcon,
    required this.label,
    required this.route,
  });
}
