import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/items.dart';
import '../widgets/store_list_item.dart';

class StoreList extends StatelessWidget {
//  Future<void> _refreshProducts(BuildContext context) async {
//    await Provider.of<Items>(context).fetchAndSetItems();
//  }

  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<Items>(context);
    final currentItems = itemsData.items;
    return currentItems.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: const FittedBox(
              child: Text(
                'There are currently no inputted items.',
                style: TextStyle(fontSize: 25.0),
              ),
            ),
          )
        : // RefreshIndicator(
//            onRefresh: () => _refreshProducts(context),
//            child:
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: currentItems[index],
                    child: StoreListItem(),
                  );
                },
                itemCount: currentItems.length,
                physics: const BouncingScrollPhysics(),
              ),
//            ),
          );
  }
}
