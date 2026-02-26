import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/bus_route.dart';

class RouteService {
  RouteService._();

  static const List<String> _routeFiles = [
    'R102-AM', 'R102-PM', 'R103-AM', 'R103-PM',
    'R402-AM', 'R402-PM', 'R403-AM', 'R403-PM',
    'R503-AM', 'R503-PM', 'R603-AM', 'R603-PM',
    'R763-AM', 'R763-PM', 'R783-AM', 'R783-PM',
    'R793-AM', 'R793-PM', 'Z999-AM',
  ];

  static Future<List<BusRoute>> loadAllRoutes() async {
    final routes = <BusRoute>[];
    for (final file in _routeFiles) {
      try {
        final jsonStr = await rootBundle.loadString('assets/routes/$file.json');
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        routes.add(BusRoute.fromJson(json));
      } catch (_) {
        // Skip missing/invalid files
      }
    }
    return routes;
  }

  static Future<BusRoute?> loadRoute(String fileName) async {
    try {
      final jsonStr =
          await rootBundle.loadString('assets/routes/$fileName.json');
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return BusRoute.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
