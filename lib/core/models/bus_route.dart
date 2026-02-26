import 'package:flutter/material.dart';
import 'route_point.dart';

class BusRoute {
  final String id;
  final String routeNumber;
  final String name;
  final String area;
  final String timePeriod; // 'AM' or 'PM'
  final Color color;
  final String startTime;
  final String endTime;
  final List<RoutePoint> points;

  const BusRoute({
    required this.id,
    required this.routeNumber,
    required this.name,
    required this.area,
    required this.timePeriod,
    required this.color,
    required this.startTime,
    required this.endTime,
    required this.points,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    final colorHex = (json['color'] as String).replaceFirst('#', '');
    return BusRoute(
      id: json['id'] as String,
      routeNumber: json['route_number'] as String,
      name: json['name'] as String,
      area: json['area'] as String,
      timePeriod: json['time_period'] as String,
      color: Color(int.parse('FF$colorHex', radix: 16)),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      points: (json['points'] as List)
          .map((p) => RoutePoint.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  List<RoutePoint> get stops => points.where((p) => p.isStop).toList();
}
