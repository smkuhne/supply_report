import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './item.dart';

class Items with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items {
    return [..._items];
  }

  Future<void> fetchAndSetItems(String storeID) async {
    final uri = Uri.https(
      'pro-router-231219.appspot.com',
      '/api/v1/items/all',
      {'storeid': storeID},
    );
    print(uri); // TODO remove
    try {
      final response = await http.get(uri);
      final extractedData = json.decode(response.body) as List<dynamic>;
      final List<Item> loadedItems = [];
      extractedData.forEach((itemData) {
        loadedItems.add(Item(
          name: itemData['item_name'],
          availability: itemData['available'],
        ));
      });
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addItem(String storeID, String name, bool availability) async {
    final uri =
        Uri.https('pro-router-231219.appspot.com', '/api/v1/items/add', {
      'itemname': name,
      'storeid': storeID,
      'available': availability.toString(),
    });
    try {
      await http.post(uri);
      final newItem = Item(
        name: name,
        availability: availability,
      );
      _items.add(newItem);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeItem(String storeID, Item item) async {
    final uri =
        Uri.https('pro-router-231219.appspot.com', '/api/v1/items/remove', {
      'itemname': item.name,
      'storeid': storeID,
    });
    try {
      await http.post(uri);
      _items.remove(item);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
