import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/store.dart';
import '../models/items.dart';
import '../widgets/new_item.dart';
import '../widgets/store_list.dart';

class StorePage extends StatelessWidget {
  final Store receivedStore;

  StorePage(this.receivedStore);
  
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Items(),
      child: MyStorePage(receivedStore),
    );
  }
}

class MyStorePage extends StatelessWidget {
  final Store currentStore;

  MyStorePage(this.currentStore);

  void _openNewItem(BuildContext ctx) {
    final items = Provider.of<Items>(ctx, listen: false);
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return ListenableProvider.value(value: items, child: NewItem());
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
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
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
            StoreList(),
          ],
        ),
      ),
    );
  }
}
