import 'package:flutter/material.dart';

import '../models/item.dart';

class StoreList extends StatelessWidget {
  final List<Item> items;

  StoreList(this.items);

  void _updateItem(BuildContext ctx, String id) { // TODO I'm still working on this
    showDialog(
      context: ctx,
      builder: (bCtx) {
        return AlertDialog(
          title: const Text('Update Availability'),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                'Cancel',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              textColor: Colors.red,
              onPressed: () => Navigator.of(bCtx).pop(),
            ),
            FlatButton(
              child: const Text(
                'Confirm',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              textColor: Colors.blue,
              onPressed: () {
                Navigator.of(bCtx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const legend = {
      true: Icon(
        Icons.check,
        color: Colors.green,
      ),
      false: Icon(
        Icons.close,
        color: Colors.red,
      ),
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
        : Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: legend[items[index].availability],
                  title: Text(items[index].name),
                  trailing: FlatButton(
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {},
                  ),
                );
              },
              itemCount: items.length,
              physics: const BouncingScrollPhysics(),
            ),
          );
  }
}
