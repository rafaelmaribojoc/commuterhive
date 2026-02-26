import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  children: [
                    // Title row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Leaderboard',
                            style: GoogleFonts.fredoka(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMain,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Weekly/All-time toggle
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.textMain,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Weekly',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  'All-time',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Your rank card
                    _YourRankCard(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          // Leaderboard entries
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _TopEntry(
                  rank: 1,
                  name: '@DavaoExplorer',
                  badge: 'Hive Master',
                  badgeColor: AppColors.info,
                  level: 'Lvl 24',
                  levelColor: AppColors.info,
                  points: '15.4k',
                  pointsColor: AppColors.primaryDark,
                  borderColor: AppColors.primary,
                  trophyColor: AppColors.primary,
                  avatarSeed: 'avatar1',
                ),
                const SizedBox(height: 12),
                _TopEntry(
                  rank: 2,
                  name: '@BusRider99',
                  badge: 'Route Guide',
                  badgeColor: AppColors.success,
                  level: 'Lvl 18',
                  levelColor: AppColors.success,
                  points: '12.8k',
                  pointsColor: AppColors.textMuted,
                  borderColor: Colors.grey.shade300,
                  trophyColor: Colors.grey.shade300,
                  avatarSeed: 'avatar2',
                ),
                const SizedBox(height: 12),
                _TopEntry(
                  rank: 3,
                  name: '@JeepneyKing',
                  badge: 'Scout',
                  badgeColor: AppColors.accent,
                  level: 'Lvl 15',
                  levelColor: AppColors.accent,
                  points: '10.2k',
                  pointsColor: AppColors.textMuted,
                  borderColor: Colors.orange.shade300,
                  trophyColor: Colors.orange.shade300,
                  avatarSeed: 'avatar3',
                ),
                const SizedBox(height: 12),
                ..._buildRegularEntries(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRegularEntries() {
    final users = [
      _UserData(4, '@SarahG', 'Level 12 Scout', '8,450', 'avatar4'),
      _UserData(5, '@TrafficSlayer', 'Level 11 Scout', '7,120', 'avatar5'),
      _UserData(6, '@MigsTravels', 'Level 9 Novice', '6,890', 'avatar6'),
      _UserData(7, '@IndayBuzz', 'Level 8 Novice', '5,400', 'avatar7'),
      _UserData(8, '@DurianBoy', 'Level 7 Novice', '4,150', 'avatar8'),
    ];

    final widgets = <Widget>[];
    for (final user in users) {
      widgets.add(_RegularEntry(user: user));
      widgets.add(const SizedBox(height: 12));
    }
    return widgets;
  }
}

class _YourRankCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 6), color: Color(0xFFE5E7EB)),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative orbs
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            left: 40,
            bottom: -24,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Row(
            children: [
              // Rank
              Column(
                children: [
                  Text(
                    'RANK',
                    style: GoogleFonts.fredoka(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain.withValues(alpha: 0.7),
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    '#42',
                    style: GoogleFonts.fredoka(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
              Container(
                width: 2,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              // Avatar + info
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
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
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          'Lvl 4',
                          style: GoogleFonts.fredoka(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You',
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Scout',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain.withValues(alpha: 0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              // Nectar
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_florist,
                          size: 16,
                          color: AppColors.textMain,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '1,250',
                          style: GoogleFonts.fredoka(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NECTAR',
                    style: GoogleFonts.fredoka(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain.withValues(alpha: 0.6),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopEntry extends StatelessWidget {
  final int rank;
  final String name;
  final String badge;
  final Color badgeColor;
  final String level;
  final Color levelColor;
  final String points;
  final Color pointsColor;
  final Color borderColor;
  final Color trophyColor;
  final String avatarSeed;

  const _TopEntry({
    required this.rank,
    required this.name,
    required this.badge,
    required this.badgeColor,
    required this.level,
    required this.levelColor,
    required this.points,
    required this.pointsColor,
    required this.borderColor,
    required this.trophyColor,
    required this.avatarSeed,
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
      child: Stack(
        children: [
          // Left border accent
          Positioned(
            left: -16,
            top: -16,
            bottom: -16,
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(24),
                ),
              ),
            ),
          ),
          Row(
            children: [
              // Trophy
              SizedBox(
                width: 32,
                child: Icon(
                  Icons.emoji_events,
                  size: 28,
                  color: trophyColor,
                ),
              ),
              const SizedBox(width: 12),
              // Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade100,
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://picsum.photos/seed/$avatarSeed/200/200',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: levelColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        level,
                        style: GoogleFonts.fredoka(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Name + badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: GoogleFonts.fredoka(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Points
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    points,
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: pointsColor,
                    ),
                  ),
                  Text(
                    'PTS',
                    style: GoogleFonts.fredoka(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RegularEntry extends StatelessWidget {
  final _UserData user;

  const _RegularEntry({required this.user});

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
          SizedBox(
            width: 32,
            child: Text(
              '${user.rank}',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
            ),
            child: ClipOval(
              child: Image.network(
                'https://picsum.photos/seed/${user.avatarSeed}/200/200',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.level,
                  style: GoogleFonts.fredoka(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_florist,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                user.points,
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserData {
  final int rank;
  final String name;
  final String level;
  final String points;
  final String avatarSeed;

  const _UserData(this.rank, this.name, this.level, this.points, this.avatarSeed);
}
