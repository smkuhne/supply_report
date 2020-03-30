import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';

class StoreListItem extends StatelessWidget {
  void _updateItem(BuildContext ctx, Item item) {
    showDialog(
      context: ctx,
      builder: (bCtx) {
        return AlertDialog(
          title: const Text('Update Availability'),
          content: Row(
            children: <Widget>[
              Text('Change ${item.name} to'),
              item.availability
                  ? Row(
                      children: <Widget>[
                        Icon(Icons.close, color: Colors.red),
                        Text('Unavailable?'),
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        Icon(Icons.check, color: Colors.green),
                        Text('Available?'),
                      ],
                    )
            ],
          ),
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
                item.toggleAvailability();
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
    final currentItem = Provider.of<Item>(context);

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

    return ListTile(
      leading: legend[currentItem.availability],
      title: Text(currentItem.name),
      trailing: FlatButton(
        child: const Text(
          'Update',
          style: TextStyle(color: Colors.blue),
        ),
        onPressed: () => _updateItem(context, currentItem),
      ),
    );
  }
}
