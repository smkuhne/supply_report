import 'package:flutter/foundation.dart';

class Store {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  int currentOccupancy;

  Store({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.latitude,
    @required this.longitude,
    @required this.currentOccupancy,
  });
}
