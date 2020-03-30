import 'package:flutter/foundation.dart';

class Item with ChangeNotifier {
  final String name;
  bool availability;

  Item({
    @required this.name,
    @required this.availability,
  });

  void toggleAvailability() {
    availability = !availability;
    notifyListeners();
  }
}
