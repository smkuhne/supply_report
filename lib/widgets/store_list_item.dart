import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../models/items.dart';

class StoreListItem extends StatefulWidget {
  final String storeID;

  StoreListItem(this.storeID);

  @override
  _StoreListItemState createState() => _StoreListItemState();
}

class _StoreListItemState extends State<StoreListItem> {
  var _isLoading = false;
  var _updateItem = true;

  void _changeItem(BuildContext ctx, String storeID, Item item) {
    showDialog(
      context: ctx,
      builder: (bCtx) {
        return AlertDialog(
          title: _updateItem
              ? const Text('Update Availability')
              : const Text('Delete Item?'),
          content: _updateItem
              ? Wrap(
                  children: <Widget>[
                    Text('Change ${item.name} to'),
                    item.availability
                        ? Wrap(
                            children: <Widget>[
                              const Icon(Icons.close, color: Colors.red),
                              const Text('Unavailable?'),
                            ],
                          )
                        : Wrap(
                            children: <Widget>[
                              const Icon(Icons.check, color: Colors.green),
                              const Text('Available?'),
                            ],
                          )
                  ],
                )
              : null,
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
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  _updateItem
                      ? await item.toggleAvailability(widget.storeID, item.name)
                      : await Provider.of<Items>(context, listen: false)
                          .removeItem(widget.storeID, item);
                } catch (error) {
                  await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('An error occurred!'),
                      content: Text('Something went wrong.'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Okay'),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  );
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.of(bCtx).pop();
                }
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

    return _isLoading
        ? Center(
            child: const CircularProgressIndicator(),
          )
        : ListTile(
            leading: legend[currentItem.availability],
            title: Text(currentItem.name),
            trailing: FlatButton(
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                _updateItem = true;
                _changeItem(context, widget.storeID, currentItem);
              },
            ),
            onLongPress: () {
              _updateItem = false;
              _changeItem(context, widget.storeID, currentItem);
            },
          );
  }
}
