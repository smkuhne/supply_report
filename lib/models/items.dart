//import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

import './item.dart';

class Items with ChangeNotifier {
  List<Item> _items = [
    Item(
      name: 'Eggs',
      availability: true,
    ),
    Item(
      name: 'Milk',
      availability: false,
    ),
    Item(
      name: 'Eggs',
      availability: true,
    ),
    Item(
      name: 'Toilet Paper',
      availability: false,
    ),
    Item(
      name: 'Milk',
      availability: false,
    ),
    Item(
      name: 'Toilet Paper',
      availability: true,
    ),
    Item(
      name: 'Eggs',
      availability: true,
    ),
    Item(
      name: 'Milk',
      availability: false,
    ),
    Item(
      name: 'Eggs',
      availability: true,
    ),
    Item(
      name: 'Toilet Paper',
      availability: false,
    ),
    Item(
      name: 'Milk',
      availability: false,
    ),
    Item(
      name: 'Toilet Paper',
      availability: false,
    ),
  ];

  List<Item> get items {
    return [..._items];
  }

  Future<void> fetchAndSetItems() async {
//    const url = 'fakeurl.lalalalalala'; // TODO change
//    try {
//      final response = await http.get(url);
//      final extractedData = json.decode(response.body) as Map<String, dynamic>;
//      final List<Item> loadedItems = [];
//      extractedData.forEach((prodId, itemData) {
//        loadedItems.add(Item(
//          name: itemData['name'],
//          availability: itemData['availability'],
//        ));
//      });
//      _items = loadedItems;
//      notifyListeners();
//    } catch (error) {
//      throw (error);
//    }
  }

//  Future<void> addProduct(String name, bool availability) async {
//    const url = 'gottahavesomelink.hahahahahaha';
//    try {
//      final response = await http.post(
//        url,
//        body: json.encode({
//          'name': name,
//          'availability': availability,
//        }),
//      );
//      final newItem = Item(
////        id: json.decode(response.body)['name'], // should we have this?
//        name: name,
//        availability: availability,
//      );
//      _items.add(newItem);
//      notifyListeners();
//    } catch (error) {
//      print(error);
//      throw error;
//    }
//  }

  void addItem(String name, bool availability) {
    final newItem = Item(
      name: name,
      availability: availability,
    );
    _items.add(newItem);
    notifyListeners();
  }
}
