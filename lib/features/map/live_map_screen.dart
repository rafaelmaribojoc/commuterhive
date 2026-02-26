import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import '../../core/theme/app_colors.dart';
import '../../core/services/route_service.dart';
import '../../core/models/bus_route.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sheetController;
  double _dragOffset = 0;
  double _sheetHeight = 300;
  bool _dismissed = false;
  bool _isDismissing = false;
  double _dismissStartOffset = 0;

  mapbox.MapboxMap? _mapboxMap;
  List<BusRoute> _routes = [];

  @override
  void initState() {
    super.initState();
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    final routes = await RouteService.loadAllRoutes();
    if (mounted) {
      setState(() => _routes = routes);
      _addRoutesToMap();
    }
  }

  void _onMapCreated(mapbox.MapboxMap map) async {
    _mapboxMap = map;
    // Enable 3D buildings
    await map.style.setStyleImportConfigProperty(
      'basemap',
      'showPlaceLabels',
      true,
    );
    _addRoutesToMap();
  }

  Future<void> _addRoutesToMap() async {
    final map = _mapboxMap;
    if (map == null || _routes.isEmpty) return;

    // Add polylines for each route
    final polylineManager = await map.annotations.createPolylineAnnotationManager();
    for (final route in _routes) {
      final coords = route.points
          .map((p) => mapbox.Position(p.longitude, p.latitude))
          .toList();
      if (coords.length < 2) continue;

      await polylineManager.create(
        mapbox.PolylineAnnotationOptions(
          geometry: mapbox.LineString(coordinates: coords),
          lineColor: route.color.value,
          lineWidth: 4.0,
          lineOpacity: 0.85,
        ),
      );
    }

    // Add bus stop markers
    final pointManager = await map.annotations.createPointAnnotationManager();
    final statusLabels = ['Standing', 'Empty'];
    var labelIndex = 0;

    for (final route in _routes) {
      for (final stop in route.stops) {
        final label = statusLabels[labelIndex % statusLabels.length];
        labelIndex++;

        await pointManager.create(
          mapbox.PointAnnotationOptions(
            geometry: mapbox.Point(
              coordinates: mapbox.Position(stop.longitude, stop.latitude),
            ),
            iconSize: 0.8,
            textField: '🚌 $label',
            textSize: 10.0,
            textOffset: [0, 1.8],
            textColor: label == 'Empty' ? 0xFF00C896 : 0xFFFFAB00,
            textHaloColor: 0xFFFFFFFF,
            textHaloWidth: 1.5,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _onDragUpdate(double dy) {
    if (_isDismissing) return;
    setState(() {
      _dragOffset = (_dragOffset + dy).clamp(0, double.infinity);
    });
  }

  void _onDragEnd(double velocity) {
    if (_isDismissing) return;
    if (_dragOffset > _sheetHeight * 0.3 || velocity > 300) {
      _animateDismiss();
    } else {
      _animateSnapBack();
    }
  }

  void _animateDismiss() {
    _isDismissing = true;
    _dismissStartOffset = _dragOffset;
    _sheetController.duration = const Duration(milliseconds: 350);
    _sheetController.reset();
    _sheetController.forward().then((_) {
      if (mounted) {
        setState(() {
          _dismissed = true;
          _isDismissing = false;
          _dragOffset = 0;
        });
      }
    });
    // Animate from current offset to fully off-screen
    _sheetController.addListener(_dismissListener);
  }

  void _dismissListener() {
    final t = Curves.easeInCubic.transform(_sheetController.value);
    final target = _sheetHeight + 80; // slide fully past bottom
    setState(() {
      _dragOffset = _dismissStartOffset + (target - _dismissStartOffset) * t;
    });
    if (_sheetController.isCompleted) {
      _sheetController.removeListener(_dismissListener);
    }
  }

  void _animateSnapBack() {
    final startOffset = _dragOffset;
    _sheetController.duration = const Duration(milliseconds: 250);
    _sheetController.reset();

    late VoidCallback listener;
    listener = () {
      final t = Curves.easeOut.transform(_sheetController.value);
      setState(() {
        _dragOffset = startOffset * (1 - t);
      });
      if (_sheetController.isCompleted) {
        _sheetController.removeListener(listener);
        _sheetController.reset();
        setState(() => _dragOffset = 0);
      }
    };

    _sheetController.addListener(listener);
    _sheetController.forward();
  }

  void _hideSheet() {
    _animateDismiss();
  }

  void _showSheet() {
    setState(() {
      _dismissed = false;
      _isDismissing = false;
      _dragOffset = _sheetHeight + 80; // start off-screen
    });
    _sheetController.duration = const Duration(milliseconds: 400);
    _sheetController.reset();

    late VoidCallback listener;
    final startOffset = _sheetHeight + 80.0;
    listener = () {
      final t = Curves.easeOutCubic.transform(_sheetController.value);
      setState(() {
        _dragOffset = startOffset * (1 - t);
      });
      if (_sheetController.isCompleted) {
        _sheetController.removeListener(listener);
        _sheetController.reset();
        setState(() => _dragOffset = 0);
      }
    };

    _sheetController.addListener(listener);
    _sheetController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // MapBox 3D Map
        Positioned.fill(
          child: mapbox.MapWidget(
            key: const ValueKey('mapbox_map'),
            cameraOptions: mapbox.CameraOptions(
              center: mapbox.Point(
                coordinates: mapbox.Position(125.61, 7.07),
              ),
              zoom: 13,
              pitch: 45,
              bearing: 0,
            ),
            styleUri: mapbox.MapboxStyles.STANDARD,
            onMapCreated: _onMapCreated,
          ),
        ),

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
              if (_dismissed) ...[
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
        if (!_dismissed)
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).size.height * 0.12,
            child: Transform.translate(
              offset: Offset(0, _dragOffset),
              child: _RouteInfoSheet(
                onDismiss: _hideSheet,
                onDragUpdate: _onDragUpdate,
                onDragEnd: _onDragEnd,
                onMeasured: (height) => _sheetHeight = height,
              ),
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
  final ValueChanged<double> onDragUpdate;
  final ValueChanged<double> onDragEnd;
  final ValueChanged<double> onMeasured;

  const _RouteInfoSheet({
    required this.onDismiss,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onMeasured,
  });

  @override
  Widget build(BuildContext context) {
    // Measure the sheet height after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null) onMeasured(box.size.height);
    });

    return GestureDetector(
      onVerticalDragUpdate: (details) => onDragUpdate(details.delta.dy),
      onVerticalDragEnd: (details) =>
          onDragEnd(details.primaryVelocity ?? 0),
      child: Container(
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
            // Drag handle — tap to dismiss
            GestureDetector(
              onTap: onDismiss,
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

