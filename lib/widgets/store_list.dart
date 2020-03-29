import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/items.dart';
import '../widgets/store_list_item.dart';

class StoreList extends StatelessWidget {
  final String storeID;
  final ScrollController scrollController;

  StoreList(this.storeID, this.scrollController);

  Future<void> _refreshItems(BuildContext context) async {
    await Provider.of<Items>(context, listen: false).fetchAndSetItems(storeID);
  }

  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<Items>(context);
    final currentItems = itemsData.items;
    return currentItems.isEmpty
        ? Expanded(
            child: RefreshIndicator(
              onRefresh: () => _refreshItems(context),
              child: const SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: const FittedBox(
                    child: Text(
                      'There are currently no inputted items.',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Expanded(
            child: RefreshIndicator(
              onRefresh: () => _refreshItems(context),
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: currentItems[index],
                    child: StoreListItem(),
                  );
                },
                itemCount: currentItems.length,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
              ),
            ),
          );
  }
}
