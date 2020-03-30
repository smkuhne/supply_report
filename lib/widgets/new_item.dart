import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/items.dart';

class NewItem extends StatefulWidget {
  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _nameController = TextEditingController();
  bool inStock = false;
  bool availableSelected = false;

  void _submitInput() {
    final enteredName = _nameController.text;
    final enteredAvailability = inStock;

    if (enteredName.isNotEmpty) {
      Provider.of<Items>(context, listen: false)
          .addItem(enteredName, enteredAvailability);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10.0,
          ),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Item Name'),
                controller: _nameController,
                onSubmitted: (_) => _submitInput(),
              ),
              Container(
                height: 70.0,
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.check, color: Colors.green),
                          Text('Available'),
                        ],
                      ),
                      onPressed: availableSelected
                          ? null
                          : () {
                              setState(() {
                                inStock = true;
                                availableSelected = true;
                              });
                            },
                    ),
                    const SizedBox(width: 10.0),
                    RaisedButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.close, color: Colors.red),
                          Text('Unavailable')
                        ],
                      ),
                      onPressed: availableSelected
                          ? () {
                              setState(() {
                                inStock = false;
                                availableSelected = false;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    child: const Text('Cancel'),
                    color: Colors.red,
                    textColor: Colors.white,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 10.0),
                  RaisedButton(
                    child: const Text('Add Item'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: _submitInput,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
