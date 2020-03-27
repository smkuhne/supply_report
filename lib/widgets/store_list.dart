import 'package:flutter/material.dart';

import '../models/item.dart';

class StoreList extends StatelessWidget {
  final List<Item> items;

  StoreList(this.items);

  @override
  Widget build(BuildContext context) {
    const legend = {
      1: Icon(
        Icons.check,
        color: Colors.green,
      ),
      -1: Icon(
        Icons.close,
        color: Colors.red,
      ),
      0: Icon(Icons.help),
    };

    return items.isEmpty
        ? Column(
            children: <Widget>[
              const Text(
                'There are no inputted items.',
              ),
              const SizedBox(height: 20.0),
              const Text('Tap the + button below to input an item.'),
            ],
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: legend[items[index].availability],
                title: Text(items[index].name),
              );
            },
            itemCount: items.length,
            physics: const BouncingScrollPhysics(),
          );
  }
}
