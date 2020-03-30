import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/items.dart';

class NewItem extends StatefulWidget {
  final String storeID;

  NewItem(this.storeID);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _nameController = TextEditingController();
  var _inStock = false;
  var _availableSelected = false;
  var _isLoading = false;

  Future<void> _submitInput() async {
    final enteredName = _nameController.text;
    final enteredAvailability = _inStock;

    if (enteredName.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Items>(context, listen: false)
            .addItem(widget.storeID, enteredName, enteredAvailability);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error has occured!'),
            content: const Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Okay'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = true;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: const CircularProgressIndicator(),
          )
        : SingleChildScrollView(
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
                      decoration: const InputDecoration(labelText: 'Item Name'),
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
                                const Icon(Icons.check, color: Colors.green),
                                const Text('Available'),
                              ],
                            ),
                            onPressed: _availableSelected
                                ? null
                                : () {
                                    setState(() {
                                      _inStock = true;
                                      _availableSelected = true;
                                    });
                                  },
                          ),
                          const SizedBox(width: 10.0),
                          RaisedButton(
                            child: Row(
                              children: <Widget>[
                                const Icon(Icons.close, color: Colors.red),
                                const Text('Unavailable')
                              ],
                            ),
                            onPressed: _availableSelected
                                ? () {
                                    setState(() {
                                      _inStock = false;
                                      _availableSelected = false;
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
