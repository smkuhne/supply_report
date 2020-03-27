import 'package:flutter/material.dart';

import '../models/item.dart';
import '../widgets/store_list.dart';

class StorePage extends StatelessWidget {
  final String storeName;

  StorePage(this.storeName);

  final List<Item> storeItems = [
    Item(
      name: 'Eggs',
      availability: 1,
    ),
    Item(
      name: 'Milk',
      availability: -1,
    ),
    Item(
      name: 'Eggs',
      availability: 1,
    ),
    Item(
      name: 'Toilet Paper',
      availability: 0,
    ),
    Item(
      name: 'Milk',
      availability: -1,
    ),
    Item(
      name: 'Toilet Paper',
      availability: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text(storeName),
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
                'Label Information',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(thickness: 1.0),
            const ListTile(
              leading: Icon(
                Icons.check,
                color: Colors.green,
              ),
              title: Text('Available'),
            ),
            const ListTile(
              leading: Icon(
                Icons.close,
                color: Colors.red,
              ),
              title: Text('Unavailable'),
            ),
            const ListTile(
              leading: Icon(Icons.help),
              title: Text('Unknown'),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
//          Text('Search Bar goes here'),
          Container(
            height: availableHeight,
            child: StoreList(storeItems),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
