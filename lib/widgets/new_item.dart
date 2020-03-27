import 'package:flutter/material.dart';

class NewItem extends StatefulWidget {
  final Function appendItem;

  NewItem(this.appendItem);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _nameController = TextEditingController();
  bool inStock;

  void _submitInput() {
    final enteredName = _nameController.text;
    final enteredAvailability = inStock;

    if ((enteredName.isNotEmpty) && (inStock != null)) {
      widget.appendItem(
        enteredName,
        enteredAvailability,
      );
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
                      onPressed: () {
                        inStock = true;
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
                      onPressed: () {
                        inStock = false;
                      },
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
