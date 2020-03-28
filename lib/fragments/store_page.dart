import 'package:flutter/material.dart';

import '../models/item.dart';
import '../models/store.dart';
import '../widgets/new_item.dart';
import '../widgets/store_list.dart';

class StorePage extends StatefulWidget {
  final int storeID;

  StorePage(this.storeID);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final currentStore = Store(
    id: 0,
    name: 'Safeway',
    address: '1234 pizza road\nBig City, CA 12345',
    latitude: 123,
    longitude: 123,
    currentOccupancy: 1211231231231231233,
  ); // TODO find store from store id

  final List<Item> storeItems = [
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

  void _addItem(String nameInput, bool availabilityInput) {
    final currentExpense = Item(
      name: nameInput,
      availability: availabilityInput,
    );

    setState(() {
      storeItems.add(currentExpense);
    });
  }

  void _openNewItem(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return NewItem(_addItem);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text(currentStore.name),
      actions: <Widget>[
        Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => Scaffold.of(ctx).openEndDrawer(),
          ),
        ),
      ],
    );
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            const ListTile(
              title: Text(
                'Store Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1.0,
            ),
            ListTile(
              title: Text(currentStore.address),
            ),
            ListTile(
              title: Text('Estimated Current Occupancy: ' +
                  currentStore.currentOccupancy.toString()),
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: availableHeight,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 10.0,
                right: 10.0,
              ),
              child: TextField(
                onChanged: (value) {
//                  filterSearchResults(value);
                },
//                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)))),
              ),
            ),
            ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Stock',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              title: Text(
                'Store Item',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: RaisedButton(
                child: Text('Add Item'),
                onPressed: () => _openNewItem(context),
              ),
            ),
            Divider(height: 1.0, thickness: 1.0),
            StoreList(storeItems),
          ],
        ),
      ),
    );
  }
}
