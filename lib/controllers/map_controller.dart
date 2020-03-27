import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController {
  void Function() updateCurrentPosition;
  LatLng position;
}