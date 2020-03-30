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
  var _updateMode = true;

  void _changeItem(BuildContext ctx, String storeID, Item item) {
    showDialog(
      context: ctx,
      builder: (bCtx) {
        return AlertDialog(
          title: _updateMode
              ? const Text('Update Availability')
              : const Text('Delete Item?'),
          content: _updateMode
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
                  _updateMode
                      ? item.toggleAvailability(widget.storeID, item.name)
                      : Provider.of<Items>(context).removeItem(storeID, item);
                } catch (error) {
                  await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('An error has occured!'),
                      content: const Text('Something went wrong.'),
                      actions: <Widget>[
                        FlatButton(
                          child: const Text('Okay'),
                          onPressed: () => Navigator.of(context).pop(), // TODO maybe wrong context
                        ),
                      ],
                    ),
                  );
                } finally {
                  setState(() {
                    _isLoading = true;
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
                _updateMode = true;
                _changeItem(context, widget.storeID, currentItem);
              },
            ),
            onLongPress: () {
              _updateMode = false;
              _changeItem(context, widget.storeID, currentItem);
            },
          );
  }
}
