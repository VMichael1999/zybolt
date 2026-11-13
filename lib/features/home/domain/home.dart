import 'package:equatable/equatable.dart';

class CurrentDelivery extends Equatable {
  const CurrentDelivery({
    required this.trackingNumber,
    required this.status,
    required this.sentOn,
    required this.estimatedOn,
  });

  final String trackingNumber;
  final String status;
  final DateTime sentOn;
  final DateTime estimatedOn;

  @override
  List<Object?> get props => [trackingNumber, status, sentOn, estimatedOn];
}

class ActiveShipment extends Equatable {
  const ActiveShipment({
    required this.flagA,
    required this.flagB,
    required this.from,
    required this.to,
    required this.order,
    required this.delivered,
    required this.statusLabel,
  });

  final String flagA;
  final String flagB;
  final String from;
  final String to;
  final String order;
  final bool delivered;
  final String statusLabel;

  @override
  List<Object?> get props => [
    flagA,
    flagB,
    from,
    to,
    order,
    delivered,
    statusLabel,
  ];
}

class WeekDay extends Equatable {
  const WeekDay(this.label, this.height, {this.highlight = false, this.value});

  final String label;
  final double height;
  final bool highlight;
  final String? value;

  @override
  List<Object?> get props => [label, height, highlight, value];
}

class WeeklyStats extends Equatable {
  const WeeklyStats({
    required this.range,
    required this.parcelsSent,
    required this.growth,
    required this.days,
    required this.onTimePercent,
    required this.avgDays,
    required this.spent,
  });

  final String range;
  final int parcelsSent;
  final String growth;
  final List<WeekDay> days;
  final int onTimePercent;
  final String avgDays;
  final double spent;

  @override
  List<Object?> get props => [
    range,
    parcelsSent,
    growth,
    days,
    onTimePercent,
    avgDays,
    spent,
  ];
}

enum UpdateType { live, normal, success }

class TrackingUpdate extends Equatable {
  const TrackingUpdate({
    required this.time,
    required this.title,
    required this.detail,
    required this.icon,
    required this.type,
  });

  final String time;
  final String title;
  final String detail;
  final String icon;
  final UpdateType type;

  @override
  List<Object?> get props => [time, title, detail, icon, type];
}

class DropOffPoint extends Equatable {
  const DropOffPoint({
    required this.number,
    required this.name,
    required this.detail,
    required this.status,
    required this.distanceKm,
    required this.open,
    this.lat = 0,
    this.lng = 0,
  });

  final int number;
  final String name;
  final String detail;
  final String status;
  final double distanceKm;
  final bool open;
  final double lat;
  final double lng;

  @override
  List<Object?> get props => [
    number,
    name,
    detail,
    status,
    distanceKm,
    open,
    lat,
    lng,
  ];
}

class HomeSummary extends Equatable {
  const HomeSummary({
    required this.userName,
    required this.greeting,
    required this.current,
    required this.shipments,
    required this.stats,
    required this.updates,
    required this.dropOffs,
  });

  final String userName;
  final String greeting;
  final CurrentDelivery current;
  final List<ActiveShipment> shipments;
  final WeeklyStats stats;
  final List<TrackingUpdate> updates;
  final List<DropOffPoint> dropOffs;

  int get openDropOffs => dropOffs.where((d) => d.open).length;

  @override
  List<Object?> get props => [
    userName,
    greeting,
    current,
    shipments,
    stats,
    updates,
    dropOffs,
  ];
}

abstract class HomeRepository {
  Future<HomeSummary> loadSummary();
}
