import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Item with ChangeNotifier {
  final String name;
  bool availability;

  Item({
    @required this.name,
    @required this.availability,
  });

  Future<void> toggleAvailability(String storeID, String itemName) async {
    availability = !availability;
    final uri =
    Uri.https('pro-router-231219.appspot.com', '/api/v1/items/add', {
      'itemname': itemName,
      'storeid': storeID,
      'available': availability.toString(),
    });
    try {
      await http.post(uri);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
