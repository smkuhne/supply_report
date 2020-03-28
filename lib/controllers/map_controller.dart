import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController {
  void Function(bool enabled) setNewStore;
  void Function() reload;
}