import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      name: 'Eggs1',
      availability: true,
    ),
    Item(
      name: 'Toilet Paper',
      availability: false,
    ),
    Item(
      name: 'Milk1',
      availability: false,
    ),
    Item(
      name: 'Toilet Paper1',
      availability: true,
    ),
    Item(
      name: 'Eggs2',
      availability: true,
    ),
    Item(
      name: 'Milk2',
      availability: false,
    ),
    Item(
      name: 'Eggs3',
      availability: true,
    ),
    Item(
      name: 'Toilet Paper2',
      availability: false,
    ),
    Item(
      name: 'Milk3',
      availability: false,
    ),
    Item(
      name: 'Toilet Paper3',
      availability: false,
    ),
    Item(
      name: 'Test',
      availability: false,
    ),
    Item(
      name: 'Test1',
      availability: true,
    ),
    Item(
      name: 'Test2',
      availability: false,
    ),
    Item(
      name: 'Test3',
      availability: false,
    ),
    Item(
      name: 'Test4',
      availability: true,
    ),
    Item(
      name: 'Test5',
      availability: false,
    ),
    Item(
      name: 'Test6',
      availability: false,
    ),
    Item(
      name: 'Test7',
      availability: true,
    ),
    Item(
      name: 'Test8',
      availability: true,
    ),
    Item(
      name: 'Test9',
      availability: false,
    ),
  ];

  List<Item> get items {
    return [..._items];
  }

  Future<void> fetchAndSetItems(String storeID) async {
//    final url = '127.0.0.1:5000/api/v1/items/all?storeid=$storeID';
//    try {
//      final response = await http.get(url);
//      final extractedData = json.decode(response.body) as Map<String, dynamic>;
//      final List<Item> loadedItems = [];
////      extractedData.forEach((prodId, itemData) {
////        loadedItems.add(Item(
////          name: itemData['name'],
////          availability: itemData['availability'],
////        ));
////      });
//      print(extractedData);
//      _items = loadedItems;
//      notifyListeners();
//    } catch (error) {
//      throw (error);
//    }
  }

//  Future<void> addItem(String storeID, String name, bool availability) async {
//    final url = '127.0.0.1:5000/api/v1/person/add?storename=$storeID';
//    try {
//      await http.post(
//        url,
//        body: json.encode({
//          'itemName': name,
//          'availability': availability,
//        }),
//      );
//      final newItem = Item(
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

  void addItem(String storeID, String name, bool availability) {
    final newItem = Item(
      name: name,
      availability: availability,
    );
    _items.add(newItem);
    notifyListeners();
  }
}
