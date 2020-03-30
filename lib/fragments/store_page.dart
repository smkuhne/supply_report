import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/items.dart';
import '../models/store.dart';
import '../widgets/new_item.dart';
import '../widgets/search_delegate.dart';
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

  final _scrollController = ScrollController();

  void _animateToIndex(index) => _scrollController.animateTo(
        (56 * index).toDouble(),
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );

  void _openSearch(BuildContext ctx, Items items) async {
    final searchItems = items.items;
    final result = await showSearch(
      context: ctx,
      delegate: ItemSearch(searchItems),
    );
    _animateToIndex(searchItems.indexOf(result));
  }

  void _openNewItem(BuildContext ctx, Items items) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return ListenableProvider.value(
            value: items, child: NewItem(currentStore.id));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final items = Provider.of<Items>(context, listen: false);
    final appBar = AppBar(
      title: Text(currentStore.name),
      actions: <Widget>[
        Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => Scaffold.of(ctx).openEndDrawer(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _openSearch(context, items),
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
            const Divider(height: 1.0, thickness: 1.0),
            ListTile(title: Text(currentStore.address)),
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
            ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('In',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text('Stock',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              title: const Text(
                'Store Item',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: RaisedButton(
                child: const Text('Add Item'),
                onPressed: () => _openNewItem(context, items),
              ),
            ),
            const Divider(height: 1.0, thickness: 1.0),
            StoreList(currentStore.id, _scrollController),
          ],
        ),
      ),
    );
  }
}
